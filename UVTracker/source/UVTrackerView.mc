using Toybox.Graphics;
using Toybox.WatchUi;

using Toybox.Graphics as Gfx;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Time.Gregorian;

class UVTrackerView extends WatchUi.View {

    var _message as String = "";

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout( Rez.Layouts.MainLayout( dc ) );
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        $.logMessage("View::onUpdate ENTER");

        var bgData = Storage.getValue($.STORAGE_UV_DATA);
        var timeDegree = 0;

        // Reset elements
        View.findDrawableById( "message_value" ).setText( "" );
        View.findDrawableById( "message_value" ).draw( dc );
        View.findDrawableById( "uv_now_value" ).setText( "" );
        View.findDrawableById( "uv_now_value" ).draw( dc );
        View.findDrawableById( "uv_max_value" ).setText( "" );
        View.findDrawableById( "uv_max_value" ).draw( dc );
        View.findDrawableById( "uv_sev_value" ).setText( "" );
        View.findDrawableById( "uv_sev_value" ).draw( dc );
        View.findDrawableById( "location_value" ).setText( "" );
        View.findDrawableById( "location_value" ).draw( dc );
        View.findDrawableById( "uv_time_value" ).setText( "" );
        View.findDrawableById( "uv_time_value" ).draw( dc );

        View.onUpdate( dc );

        // Arc width
        dc.setPenWidth( 8 );

        // Arc - No UV
        drawUVArc(dc, Gfx.COLOR_BLUE, 1, 0, 360);

        if (bgData != null && bgData["current_uv_data"] != null && bgData["forecast_uv_data"] != null ) {

            // If time between 6AM and 6PM, show UV arcs
            var systemTime = System.getClockTime();
            if ( $.DEV_MODE || (systemTime.hour > 6 && systemTime.hour < 18)) {

                var uvForecast = bgData["forecast_uv_data"];
                for (var i = 0; i < uvForecast.size(); i++) {
                    var segment = uvForecast[i];
                    var color = $.getUVSeverityColor(segment["severity"]);
                    var startDegrees = $.convertTimeToDegrees($.getMomentByTimeString(segment["startDate"]));
                    var endDegrees = $.convertTimeToDegrees($.getMomentByTimeString(segment["endDate"]));
                    drawUVArc(dc, color, 2, startDegrees, endDegrees);
                }

                // Arc - Max UV
                // if (bgData["current_uv_data"]["uv_max_time"] != null) {
                //     timeDegree = $.convertTimeToDegrees($.getMomentByTimeString(bgData["current_uv_data"]["uv_max_time"]));
                //     drawUVArc(dc, Gfx.COLOR_DK_RED, 2, timeDegree + 15, timeDegree - 15);
                // }
            }

            // Clock
            timeDegree = $.convertTimeToDegrees(Time.now());
            drawUVArc(dc, Gfx.COLOR_BLACK, 3, timeDegree + 3, timeDegree - 3);
            drawUVArc(dc, Gfx.COLOR_WHITE, 3, timeDegree + 1, timeDegree - 1);
            
            var uvValue = bgData["current_uv_data"]["uv"];
            if (uvValue instanceof Float || uvValue instanceof Number) {
                var sev = getUVSeverity(uvValue);
                View.findDrawableById( "uv_now_value" ).setText( uvValue.format("%.1f") );
                View.findDrawableById( "uv_now_value" ).draw( dc );

                View.findDrawableById( "uv_sev_value" ).setText( sev["severity"] );
                View.findDrawableById( "uv_sev_value" ).draw( dc );

                var uvExposureMins = bgData["current_uv_data"]["safe_exposure_time"]["st1"];
                if (uvExposureMins instanceof Number) {
                    var uvExposureHours = uvExposureMins.toFloat() / 60.0;
                    _message = "Safe exposure time: " + uvExposureHours.format("%.1f") + " hours";
                } else {
                    _message = "You are currently safe";
                }
            }

            var uvMaxValue = bgData["current_uv_data"]["uv_max"];
            if (uvMaxValue instanceof Float || uvMaxValue instanceof Number) {
                View.findDrawableById( "uv_max_value" ).setText( uvMaxValue.format("%.1f") );
                View.findDrawableById( "uv_max_value" ).draw( dc );
            }

            View.findDrawableById( "uv_time_value" ).setText( $.getTime() );
            View.findDrawableById( "uv_time_value" ).draw( dc );
                
            var locationData = bgData["location_data"];
            if (locationData != null) {
                var location = locationData["country"];
                if (locationData["village"] != null) {
                    location = locationData["village"] + ", " + location;
                } else if (locationData["municipality"] != null) {
                    location = locationData["municipality"] + ", " + location;
                } else if (locationData["city"] != null) {
                    location = locationData["city"] + ", " + location;
                }
                View.findDrawableById( "location_value" ).setText( location );
                View.findDrawableById( "location_value" ).draw( dc );
            }
        } else {
            _message = "No data available yet";
        }

        View.findDrawableById( "message_value" ).setText( _message );
        View.findDrawableById( "message_value" ).draw( dc );

        $.logMessage("View::onUpdate EXIT");
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function drawUVArc(dc as DC, color, radiusOffset, degreeStart, degreeEnd) {

        var CENTER_X = dc.getWidth() / 2;
        var CENTER_Y = dc.getHeight() / 2;

        dc.setColor( color, Gfx.COLOR_BLACK );
        dc.drawArc( CENTER_X, CENTER_Y, CENTER_X - radiusOffset, Gfx.ARC_CLOCKWISE, degreeStart, degreeEnd );
    }

    function getUVSeverity(value) {

        var level = 0;
        var severity;

        if (value < 3) {
            level = 1;
            severity = Rez.Strings.uv_low;
        } else if (value >= 3 && value < 6) {
            level = 2;
            severity = Rez.Strings.uv_medium;
        } else if (value >= 6 && value < 8) {
            level = 3;
            severity = Rez.Strings.uv_high;
        } else if (value >= 8 && value < 11) {
            level = 4;
            severity = Rez.Strings.uv_veryhigh;
        } else if (value >= 11) {
            level = 5;
            severity = Rez.Strings.uv_extreme;
        } else {
            severity = Rez.Strings.uv_unknown;
        }
        return {
            "level" => level,
            "severity" => severity
        };
    }

}
