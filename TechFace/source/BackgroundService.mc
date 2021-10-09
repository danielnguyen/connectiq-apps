using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Background;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

(:background)
class BackgroundService extends System.ServiceDelegate {

    private var OPENUV_API_KEY;

    private var OPENUV_UV_API = "https://api.openuv.io/api/v1/uv";
    private var OPENCOVID_TIMESERIES_API = "https://api.opencovid.ca/timeseries";
    private var DEFAULT_REQUEST_COUNT = 1;

    private var _positionInfo = null;
    private var bgData;

    private var reqCount;
		
	function initialize() {
		//$.logMessage(" *** Printed by BgbgServiceDelegate initialize() first line ***");
		System.ServiceDelegate.initialize();
        reqCount = DEFAULT_REQUEST_COUNT;
	}

    function exitReq() {

        reqCount--;

        if (reqCount == 0) {
            $.logMessage("API requests completed. Exiting Background Service.");
            // Reset reqCount;
            reqCount = DEFAULT_REQUEST_COUNT;
            Background.exit(bgData);
        }
    }
	
    //A callback method that is triggered in the background when time-based events occur.
    function onTemporalEvent() {
    	$.logMessage("Making request");

        bgData = {};

        var app = Application.getApp();

        OPENUV_API_KEY = app.getProperty("OPENUV_API_KEY");
        if (OPENUV_API_KEY != null && OPENUV_API_KEY instanceof String && OPENUV_API_KEY.length() > 0) {

            var activityInfo = Activity.getActivityInfo();

            // Get latest location from Activity Info
            if (activityInfo.currentLocation != null) {
                _positionInfo = activityInfo.currentLocation.toDegrees();
            } else {
                $.logMessage("Activity Info current location is null");
                // Try to use last known location
                _positionInfo = Storage.getValue("position");
            }
        
            // If location still null
            if (_positionInfo == null)  {
                $.logMessage("Unable to get position (ActivityInfo or cache)");
            } else {
                reqCount++;
                makeRequest_OpenUV();
            }
        }
        makeRequest_OpenCovid();
        bgData["updated"] = Time.now().value();
    }

    //! Make the web request to OpenUV
    private function makeRequest_OpenUV() {
        $.logMessage("BackgroundService::makeRequest_OpenUV ENTER");

        // enterReq();
        if ($.DEV_MODE) {
            onReceive_OpenUV(200, $.TESTDATA_OPENUV_UV);
        } else {
            var options = {
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
                :headers => {
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
                    "x-access-token" => OPENUV_API_KEY
                }
            };

            if (_positionInfo != null) {
                var url = OPENUV_UV_API + "?lat=" + _positionInfo[0] + "&lng=" + _positionInfo[1];
                $.logMessage("Performing API call: " + url);
                Communications.makeJsonRequest(
                    url,
                    {
                        "lat" => _positionInfo[0],
                        "lng" => _positionInfo[1]
                    },
                    options,
                    method(:onReceive_OpenUV)
                );
            } else {
                $.logMessage("Position not available");
            }
        }
        $.logMessage("BackgroundService::makeRequest_OpenUV EXIT");
    }

    //! Make the web request to OpenUV
    private function makeRequest_OpenCovid() {
        $.logMessage("BackgroundService::makeRequest_OpenCovid ENTER");
        // enterReq();
        if ($.DEV_MODE) {

            onReceive_OpenCovid(200, $.TESTDATA_OPENCOVID_ON);
            
        } else {

            var options = {
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
                :headers => {
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
                }
            };

            var afterDate = "";

            var sevenDaysAgoMoment = Time.today().subtract(new Time.Duration(14 * 86400)); // 14 days for rolling 7-day average
            var sevenDaysAgo = Gregorian.info(sevenDaysAgoMoment, Time.FORMAT_SHORT);
            afterDate += sevenDaysAgo.day.format("%02d") + "-" + sevenDaysAgo.month.format("%02d") + "-" + sevenDaysAgo.year;
            
            $.logMessage("Performing API call: " + OPENCOVID_TIMESERIES_API);
            Communications.makeJsonRequest(
                OPENCOVID_TIMESERIES_API,
                {
                    "stat" => "cases",
                    "loc" => "ON",
                    "after" => afterDate
                },
                options,
                method(:onReceive_OpenCovid)
            );
        }
        $.logMessage("BackgroundService::makeRequest_OpenCovid EXIT");
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive_OpenUV(responseCode as Number, data as Dictionary?) as Void {
        $.logMessage("BackgroundService::onReceive_OpenUV ENTER");
        $.logMessage("Response Code: " + responseCode);
   		if(responseCode == 200) {
            bgData["uv"] = data["result"]["uv"];
       	} else {
            $.logMessage("Received response code: " + responseCode);
        }

        $.logMessage("BackgroundService::onReceive_OpenUV EXIT");
        exitReq();
    }

    public function onReceive_OpenCovid(responseCode as Number, data as Dictionary?) as Void {
        $.logMessage("BackgroundService::onReceive_OpenCovid ENTER");
        $.logMessage("Response Code: " + responseCode);
        if (data != null) {
            var historicalData = getSevenDayAverages(data["cases"]);
            saveData(responseCode, historicalData, "covid19data_14days");
        }
        $.logMessage("BackgroundService::onReceive_OpenCovid EXIT");
       	exitReq();
    }

	// Return an array of 7-day averages of case counts
	private function getSevenDayAverages(data) {
		// $.logMessage("Covid::getSevenDayAverages ENTER");
		
		var ret = [];
		
		if (data.size() > 7) {
			for (var i=7;i<data.size();i++) { // Start at index 6 to begin calculating 7-day average
				var total = 0;
				var sevenDaysData = data.slice(i-7, i);
				for (var d=0;d<sevenDaysData.size();d++) {
					total += sevenDaysData[d]["cases"];
				}
				ret.add(total / sevenDaysData.size());
			}
		} else {
			var total = 0;
			for (var i=0;i<data.size();i++) {
				total += data[i]["cases"];
			}
			ret.add(total / data.size());
		}

		// $.logMessage("Covid::getSevenDayAverages EXIT");
		return ret;
	}

    private function saveData(responseCode as Number, data as Dictionary?, location as String) as Void {
        $.logMessage("BackgroundService::saveData ENTER");
        $.logMessage("Response Code: " + responseCode);
        if(responseCode == 200) {
   			bgData[location] = data;
       	} else {
            $.logMessage("Received response code: " + responseCode);
        }

        $.logMessage("BackgroundService::saveData EXIT");
    }
}