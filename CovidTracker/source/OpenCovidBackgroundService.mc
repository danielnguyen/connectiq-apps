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
class OpenCovidBackgroundService extends System.ServiceDelegate {

    private var OPENCOVID_SUMMARY_API = "https://api.opencovid.ca/summary";
    private var OPENCOVID_TIMESERIES_API = "https://api.opencovid.ca/timeseries";
    private var DEFAULT_REQUEST_COUNT = 1;

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

        makeRequest();
        bgData["updated"] = Time.now().value();
    }

    //! Make the web request to OpenUV
    private function makeRequest() {
        $.logMessage("BackgroundService::makeRequest ENTER");

        var loc = Application.getApp().getProperty("selected_location");
        loc = getLocationCodeByIndex(loc);

        // enterReq();
        if ($.DEV_MODE) {

            onReceive(200, $.TESTDATA_OPENCOVID_ON);
            // onReceive_TOR(200, $.TESTDATA_OPENCOVID_TOR);
            // onReceive_YORK(200, $.TESTDATA_OPENCOVID_YORK);
            
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
            
            $.logMessage("Performing API call: " + OPENCOVID_TIMESERIES_API + "?stat=cases&loc=" + loc + "&after=" + afterDate);
            Communications.makeJsonRequest(
                OPENCOVID_TIMESERIES_API,
                {
                    "stat" => "cases",
                    "loc" => loc,
                    "after" => afterDate
                },
                options,
                method(:onReceive)
            );
            
            // $.logMessage("Performing API call: " + OPENCOVID_SUMMARY_API);
            // Communications.makeJsonRequest(
            //     OPENCOVID_SUMMARY_API,
            //     {
            //         "loc" => "3595"
            //     },
            //     options,
            //     method(:onReceive_TOR)
            // );
            
            // $.logMessage("Performing API call: " + OPENCOVID_SUMMARY_API);
            // Communications.makeJsonRequest(
            //     OPENCOVID_SUMMARY_API,
            //     {
            //         "loc" => "3570"
            //     },
            //     options,
            //     method(:onReceive_YORK)
            // );
        }
        $.logMessage("BackgroundService::makeRequest EXIT");
    }

    public function onReceive(responseCode as Number, data as Dictionary?) as Void {
        $.logMessage("BackgroundService::onReceive ENTER");
        $.logMessage("Response Code: " + responseCode);
        if (data != null) {
            var historicalData = getSevenDayAverages(data["cases"]);
            saveData(responseCode, historicalData, "covid19data_14days");

            saveData(responseCode, data["cases"][data["cases"].size()-1], "covid19data");
        }
        $.logMessage("BackgroundService::onReceive EXIT");
       	exitReq();
    }

    // public function onReceive_TOR(responseCode as Number, data as Dictionary?) as Void {
    //     $.logMessage("BackgroundService::onReceive_TOR ENTER");
    //     $.logMessage("Response Code: " + responseCode);
    //     if (data != null) {
    //         onReceive(responseCode, data["summary"][data.size()-1], "covid19data_tor");
    //     }
    //     $.logMessage("BackgroundService::onReceive_TOR EXIT");
    //    	exitReq();
    // }

    // public function onReceive_YORK(responseCode as Number, data as Dictionary?) as Void {
    //     $.logMessage("BackgroundService::onReceive_YORK ENTER");
    //     $.logMessage("Response Code: " + responseCode);
    //     if (data != null) {
    //         onReceive(responseCode, data["summary"][data.size()-1], "covid19data_york");
    //     }
    //     $.logMessage("BackgroundService::onReceive_YORK EXIT");
    //    	exitReq();
    // }

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
	
	function getLocationCodeByIndex(value) {
	    if (value > $.LOCATIONS.size() || $.LOCATIONS[value][:code] == null) {
	        return null;
	    }
	    return $.LOCATIONS[value][:code];
	}
}