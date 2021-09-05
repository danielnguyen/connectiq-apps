using Toybox.Application.Storage;
using Toybox.Communications;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;

(:background)
class OpenUVServiceDelegate extends System.ServiceDelegate {

    private var OPENUV_UV_API           = "https://api.openuv.io/api/v1/uv";
    private var OPENUV_FORECAST_API     = "https://api.openuv.io/api/v1/forecast";
    private var NOMINATIM_REVERSE_API   = "https://nominatim.openstreetmap.org/reverse";

    hidden var reqCounter = 3; // Number of requests
	hidden var bgData = {};
    private var _positionInfo;
	
	function exitReq(){
		reqCounter --;
		$.logMessage("exitReq: " + reqCounter);
		if (reqCounter == 0) {
            // All requests complete, reset counter and return data
            reqCounter = 3;
            Background.exit(bgData);
        } else {
            // do nothing
        }
	}
		
	function initialize() {
		//$.logMessage(" *** Printed by BgbgServiceDelegate initialize() first line ***");
		System.ServiceDelegate.initialize();
	}
	
    //A callback method that is triggered in the background when time-based events occur.
    function onTemporalEvent() {
    	$.logMessage("Making request");
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
                "x-access-token" => $.OPENUV_API_KEY
            }
        };

        // enterReq();
        if ($.DEV_MODE) {
            var data = {
                "result" => {
                    "uv" => 4.05,
                    "uv_time" => "2018-02-22T11:20:51.810Z",
                    "uv_max" => 10.36,
                    "uv_max_time" => "2018-02-22T04:31:33.481Z",
                    "ozone" => 287.85,
                    "ozone_time" => "2018-02-22T09:06:10.889Z",
                    "safe_exposure_time" => {
                        "st1" => 154,
                        "st2" => 185,
                        "st3" => 247,
                        "st4" => 309,
                        "st5" => 494,
                        "st6" => 926
                    },
                    "sun_info" => {
                        "sun_times" => {
                            "solarNoon" => "2018-02-24T04:31:17.645Z",
                            "nadir" => "2018-02-23T16:31:17.645Z",
                            "sunrise" => "2018-02-23T22:03:02.393Z",
                            "sunset" => "2018-02-24T10:59:32.897Z",
                            "sunriseEnd" => "2018-02-23T22:05:36.370Z",
                            "sunsetStart" => "2018-02-24T10:56:58.921Z",
                            "dawn" => "2018-02-23T21:37:58.618Z",
                            "dusk" => "2018-02-24T11:24:36.672Z",
                            "nauticalDawn" => "2018-02-23T21:08:19.955Z",
                            "nauticalDusk" => "2018-02-24T11:54:15.336Z",
                            "nightEnd" => "2018-02-23T20:37:51.434Z",
                            "night" => "2018-02-24T12:24:43.856Z",
                            "goldenHourEnd" => "2018-02-23T22:35:43.950Z",
                            "goldenHour" => "2018-02-24T10:26:51.340Z"
                        },
                        "sun_position" => {
                            "azimuth" => 1.5994787694177077,
                            "altitude" => 0.3636954472178322
                        }
                    }
                }
            };
            onReceive_OpenUV_RealTime(200, data);
        } else {
            if (_positionInfo != null) {
                Communications.makeWebRequest(
                    OPENUV_UV_API + "?lat=" + _positionInfo[0] + "&lng=" + _positionInfo[1],
                    {},
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
                "x-access-token" => $.OPENUV_API_KEY
            }
        };

        // enterReq();
        if ($.DEV_MODE) {
            var data = {
                "result" => [
                    { "uv" => 0, "uv_time" => "2018-02-23T22:03:02.393Z" },
                    { "uv" => 0.3362, "uv_time" => "2018-02-23T23:03:02.393Z" },
                    { "uv" => 1.6095, "uv_time" => "2018-02-24T00:03:02.393Z" },
                    { "uv" => 4.1868, "uv_time" => "2018-02-24T01:03:02.393Z" },
                    { "uv" => 7.4569, "uv_time" => "2018-02-24T02:03:02.393Z" },
                    { "uv" => 10.35, "uv_time" => "2018-02-24T03:03:02.393Z" },
                    { "uv" => 12.1836, "uv_time" => "2018-02-24T04:03:02.393Z" },
                    { "uv" => 12.1836, "uv_time" => "2018-02-24T05:03:02.393Z" },
                    { "uv" => 10.35, "uv_time" => "2018-02-24T06:03:02.393Z" },
                    { "uv" => 7.1614, "uv_time" => "2018-02-24T07:03:02.393Z" },
                    { "uv" => 3.9424, "uv_time" => "2018-02-24T08:03:02.393Z" },
                    { "uv" => 1.4669, "uv_time" => "2018-02-24T09:03:02.393Z" },
                    { "uv" => 0.2852, "uv_time" => "2018-02-24T10:03:02.393Z" }
                ]
            };
            onReceive_OpenUV_Forecast(200, data);
        } else {
            if (_positionInfo != null) {
                Communications.makeWebRequest(
                    OPENUV_FORECAST_API + "?lat=" + _positionInfo[0] + "&lng=" + _positionInfo[1],
                    {},
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
            var data = {
                "place_id" => 9601313,
                "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
                "osm_type" => "node",
                "osm_id" => 965993073,
                "lat" => "54.982375",
                "lon" => "9.283268",
                "display_name" => "6, Bredhøjvej, Bolderslev, Aabenraa Municipality, Region of Southern Denmark, 6392, Denmark",
                "address" => {
                    "house_number" => "6",
                    "road" => "Bredhøjvej",
                    "village" => "Bolderslev",
                    "municipality" => "Aabenraa Municipality",
                    "state" => "Region of Southern Denmark",
                    "postcode" => "6392",
                    "country" => "Denmark",
                    "country_code" => "dk"
                },
                "boundingbox" => ["54.982325", "54.982425", "9.283218", "9.283318"]
            };
            onReceive_Location(200, data);
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

                if (severity != currentSeverity) {
                    // New segment started

                    // Save previous segment
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
                    // currentSegment["endDate"] = segment["uv_time"];
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

        var severity;

        if (value < 3) {
            severity = $.UV_INDEX_LOW;
        } else if (value >= 3 && value < 6) {
            severity = $.UV_INDEX_MEDIUM;
        } else if (value >= 6 && value < 8) {
            severity = $.UV_INDEX_HIGH;
        } else if (value >= 8 && value < 11) {
            severity = $.UV_INDEX_VERY_HIGH;
        } else if (value >= 11) {
            severity = $.UV_INDEX_EXTREME;
        } else {
            severity = $.UV_INDEX_UNKNOWN;
        }
        return severity;
    }
}