using Toybox.Application.Storage;
using Toybox.Communications;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;

(:background)
class OpenUVServiceDelegate extends System.ServiceDelegate {

    private var OPENUV_API_KEY;

    private var OPENUV_UV_API           = "https://api.openuv.io/api/v1/uv";
    private var OPENUV_FORECAST_API     = "https://api.openuv.io/api/v1/forecast";
    private var NOMINATIM_REVERSE_API   = "https://nominatim.openstreetmap.org/reverse";

    private var DEFAULT_REQUEST_COUNT = 3;

	hidden var bgData = {};
    private var _positionInfo;
	
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

        var app = Application.getApp();

        OPENUV_API_KEY = app.getProperty("OPENUV_API_KEY");
        if (OPENUV_API_KEY != null && OPENUV_API_KEY instanceof String && OPENUV_API_KEY.length() > 0) {
            // Get latest locationfrom Activity Info
            var location = Activity.getActivityInfo().currentLocation;
            if (location != null) {
                $.logMessage("New location detected");
                // Update cache with latest location
                Storage.setValue($.STORAGE_LOCATION, location.toDegrees());
            }
            _positionInfo = Storage.getValue($.STORAGE_LOCATION);

            makeRequests();
        }
    }

    function makeRequests() {
        makeRequest_OpenUV_RealTime();
        makeRequest_OpenUV_Forecast();
        makeRequest_Location();
    }

    //! Make the web request to OpenUV
    private function makeRequest_OpenUV_RealTime() as Void {
        $.logMessage("Delegate::makeRequest_OpenUV_RealTime ENTER");
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
                "x-access-token" => OPENUV_API_KEY
            }
        };

        // enterReq();
        if ($.DEV_MODE) {
            onReceive_OpenUV_RealTime(200, $.TESTDATA_OPENUV_UV);
        } else {
            if (_positionInfo != null) {
                Communications.makeWebRequest(
                    OPENUV_UV_API,
                    {
                        "lat" => _positionInfo[0],
                        "lng" => _positionInfo[1]
                    },
                    options,
                    method(:onReceive_OpenUV_RealTime)
                );
            } else {
                $.logMessage("Position not available");
            }
        }
        $.logMessage("Delegate::makeRequest_OpenUV_RealTime EXIT");
    }

    //! Make the web request to OpenUV
    private function makeRequest_OpenUV_Forecast() as Void {
        $.logMessage("Delegate::makeRequest_OpenUV_Forecast ENTER");
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
                "x-access-token" => OPENUV_API_KEY
            }
        };

        // enterReq();
        if ($.DEV_MODE) {
            onReceive_OpenUV_Forecast(200, $.TESTDATA_OPENUV_FORECAST2);
        } else {
            if (_positionInfo != null) {
                Communications.makeWebRequest(
                    OPENUV_FORECAST_API,
                    {
                        "lat" => _positionInfo[0],
                        "lng" => _positionInfo[1]
                    },
                    options,
                    method(:onReceive_OpenUV_Forecast)
                );
            } else {
                $.logMessage("Position not available");
            }
        }
        $.logMessage("Delegate::makeRequest_OpenUV_Forecast EXIT");
    }

    //! Make the web request
    private function makeRequest_Location() as Void {
        $.logMessage("Delegate::makeRequest_Location ENTER");

        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };

        // enterReq();
        if ($.DEV_MODE) {
            onReceive_Location(200, $.TESTDATA_NOMINATIM_REVERSE);
        } else {
            if (_positionInfo != null) {
                Communications.makeWebRequest(
                    NOMINATIM_REVERSE_API + "?format=json&lat=" + _positionInfo[0] + "&lon=" + _positionInfo[1],
                    {},
                    options,
                    method(:onReceive_Location)
                );
            } else {
                $.logMessage("Position not available");
            }
        }
        $.logMessage("Delegate::makeRequest_Location EXIT");
    }

    public function onReceive_Location(responseCode as Number, data as Dictionary?) as Void {
        $.logMessage("Delegate::onReceive_Location ENTER");

        bgData["responseCode"] = responseCode;
		bgData["location_data"] = data["address"];
		bgData["lastUpdated"] = Time.now().value();
				
       	//System.println(bgData);
        exitReq();
        $.logMessage("Delegate::onReceive_Location EXIT");
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive_OpenUV_RealTime(responseCode as Number, data as Dictionary?) as Void {
        $.logMessage("Delegate::onReceive_OpenUV_RealTime ENTER");

        bgData["responseCode"] = responseCode;
		bgData["current_uv_data"] = data["result"];
		bgData["lastUpdated"] = Time.now().value();
				
       	//System.println(bgData);
        exitReq();
        $.logMessage("Delegate::onReceive_OpenUV_RealTime EXIT");
    }
    
    public function onReceive_OpenUV_Forecast(responseCode as Number, data as Dictionary?) as Void {
        $.logMessage("Delegate::onReceive_OpenUV_Forecast ENTER");

        // Group by UV index ranges
        // [
        //     {
        //         "severity": "low|medium|high|very_high|extreme",
        //         "startDate": "",
        //         "endDate": ""
        //     }
        // ]
        var dailyUVSegments = [];
        var currentSegment = {};
        var currentSeverity =$.UV_INDEX_UNKNOWN;

        if (data["result"] != null && data instanceof Dictionary) {
            var uvForecastSegments = data["result"];
            for (var i = 0; i < uvForecastSegments.size(); i++) {
                var segment = uvForecastSegments[i];
                var severity = getUVSeverity(segment["uv"]);

                if (i==0 || severity != currentSeverity) { // first segment or new segment
                    // Save segment
                    if (!currentSegment.isEmpty()) {
                        // se the start date of the next as the end date of the previous
                        currentSegment["endDate"] = segment["uv_time"];
                        dailyUVSegments.add(currentSegment);
                    }
                    // Start a new segment
                    currentSegment = {
                        "severity" => severity,
                        "startDate" => segment["uv_time"],
                        "endDate" => ""
                    };
                    currentSeverity = severity;
                } else {
                    // Same segment, so update endDate
                    currentSegment["endDate"] = segment["uv_time"];
                }

                if (i == uvForecastSegments.size() - 1) { // last segment
                    // Save segment
                    if (!currentSegment.isEmpty()) {
                        // se the start date of the next as the end date of the previous
                        currentSegment["endDate"] = segment["uv_time"];
                        dailyUVSegments.add(currentSegment);
                    }
                }

            }
        }

        bgData["responseCode"] = responseCode;
		bgData["forecast_uv_data"] = dailyUVSegments;
		bgData["lastUpdated"] = Time.now().value();
				
       	//System.println(bgData);
        exitReq();
        $.logMessage("Delegate::onReceive_OpenUV_Forecast EXIT");
    }

    function getUVSeverity(value) {
        var level;

        if (value < 0.2) {
            level = $.UV_INDEX_NONE;
        } else if (value >= 0.2 && value < 3) {
            level = $.UV_INDEX_LOW;
        } else if (value >= 3 && value < 6) {
            level = $.UV_INDEX_MEDIUM;
        } else if (value >= 6 && value < 8) {
            level = $.UV_INDEX_HIGH;
        } else if (value >= 8 && value < 11) {
            level = $.UV_INDEX_VERY_HIGH;
        } else if (value >= 11) {
            level = $.UV_INDEX_EXTREME;
        } else {
            level = $.UV_INDEX_UNKNOWN;
        }
        return level;
    }
}