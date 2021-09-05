using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;

function getUVSeverityColor(severity) {
    var color;

    // if/else uses less memory than switch/case
    if (severity == $.UV_INDEX_LOW) {
        color = Gfx.COLOR_GREEN;
    } else if (severity == $.UV_INDEX_MEDIUM) {
        color = Gfx.COLOR_YELLOW;
    } if (severity == $.UV_INDEX_HIGH) {
        color = Gfx.COLOR_ORANGE;
    } if (severity == $.UV_INDEX_VERY_HIGH) {
        color = Gfx.COLOR_RED;
    } if (severity == $.UV_INDEX_EXTREME) {
        color = Gfx.COLOR_PURPLE;
    } else {
        color = Gfx.COLOR_BLUE;
    } 

    return color;
}

function getTime() as String {
    var timeFormat = "$1$:$2$ $3$";
    var clockTime = System.getClockTime();
    var hours = clockTime.hour;
    var meridium = "";
    if (!System.getDeviceSettings().is24Hour) {
        if (hours > 12) {
            hours = hours - 12;
            meridium = WatchUi.loadResource(Rez.Strings.pm);
        } else {
            meridium = WatchUi.loadResource(Rez.Strings.am);
        }
    } else {
        if (Application.getApp().getProperty("UseMilitaryFormat")) {
            timeFormat = "$1$$2$";
            hours = hours.format("%02d");
        }
    }
    return Lang.format(timeFormat, [hours, clockTime.min.format("%02d"), meridium]);
}

function getMomentByTimeString(timeStamp as String) as Gregorian.Info {
    var options = {
        :year   => timeStamp.substring(0, 4).toNumber(),
        :month  => timeStamp.substring(5, 7).toNumber(),
        :day    => timeStamp.substring(8, 10).toNumber(),
        :hour   => timeStamp.substring(11, 13).toNumber(),
        :minute => timeStamp.substring(14, 16).toNumber(),
        :second => timeStamp.substring(17, 19).toNumber()
    };
    
    return Gregorian.moment(options);
}

function convertTimeToDegrees(tm as Time.Moment) as Number {

    var time = Gregorian.info(tm, Time.FORMAT_MEDIUM);

    var hours = time.hour;
    if (hours < 12) {
        hours = hours + 12;
    }

    var degrees = hours * 30; // Each hour = 30 degrees
    degrees += time.min * 0.5; // Each min = 0.5 degrees

    degrees = degrees - 90; // Offset by 3 hours (90 degrees), since 0 degrees = 3 o'clock
    degrees = 360 - degrees; // To get the real position (drawArc() draws counter clockwise)

    return degrees.toNumber(); // Round up to integer
}

