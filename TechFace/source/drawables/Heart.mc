using Toybox.Activity;
using Toybox.Attention;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Heart extends Ui.Drawable {

	var POINT_OF_ORIGIN = [0, 0];

	var MAX_HEART_RATE = 180;

	function initialize() {
		Drawable.initialize({ :identifier => "Heart" });
	}
	
	function draw(dc) {
		POINT_OF_ORIGIN = [dc.getWidth() / 2, dc.getHeight() / 2];

		var activityInfo = Activity.getActivityInfo();
		var currHR = activityInfo.currentHeartRate != null ? activityInfo.currentHeartRate : 0;

		drawHeartRate(dc, currHR);
  	}

	function drawHeartRate(dc, beat) {
		
		// var hrColor = Graphics.COLOR_WHITE;

		// if (beat instanceof Number) {
		// 	if (beat >= 90 && beat < 150) {
		// 		hrColor = Graphics.COLOR_YELLOW;
		// 	} else if (beat >= 150) {
		// 		hrColor = Graphics.COLOR_RED;
		// 	}
		// }

		var levels = 40;
		var offsetBeat = (beat * levels) / 170;
		offsetBeat = offsetBeat instanceof Float ? offsetBeat.toNumber() : offsetBeat;

		// Bar label
		var label = "HR";
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(197, 230, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_RIGHT);

		var level = (beat * 60) / MAX_HEART_RATE;

		var minDegrees = 310;
		var maxDegrees = 70;

		// Gage bar
		// dc.setPenWidth(10);
        // dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        // dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 5, Graphics.ARC_COUNTER_CLOCKWISE, minDegrees - 3, maxDegrees - 1);
		
		// Arc
		var notchWidth = 2;
		var notchSpace = 1;
		var nextDegrees = minDegrees;
		dc.setPenWidth(5);
		var fillColor = Graphics.COLOR_BLUE;
		for (var i=0;i<offsetBeat;i++) {
			if (i >= 21 && i < 35) {
				fillColor = Graphics.COLOR_YELLOW;
			} else if (i >= 35) {
				fillColor = Graphics.COLOR_RED;
			}
			
			dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
			dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 5, Graphics.ARC_CLOCKWISE, nextDegrees, nextDegrees - notchWidth);
			nextDegrees += (notchWidth + notchSpace);
		}

		// Bar guide
		dc.setPenWidth(2);
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 15, Graphics.ARC_COUNTER_CLOCKWISE, 55, maxDegrees);
		dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 15, Graphics.ARC_COUNTER_CLOCKWISE, 15, 45);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 15, Graphics.ARC_COUNTER_CLOCKWISE, minDegrees + 3, 5);

		// Bar guide numbers
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawText(205, 210, $.FONT_XXTINY, 0, Graphics.TEXT_JUSTIFY_RIGHT);
		dc.drawText(245, 105, $.FONT_XXTINY, 90, Graphics.TEXT_JUSTIFY_RIGHT);
		dc.drawText(205, 40, $.FONT_XXTINY, 150, Graphics.TEXT_JUSTIFY_RIGHT);

		// Value
		dc.setPenWidth(1);
		if (fillColor == Graphics.COLOR_BLUE) { fillColor = Graphics.COLOR_WHITE; }
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(200, 87, $.FONT_XXTINY, "BPM", Graphics.TEXT_JUSTIFY_LEFT);
		dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(195, 77, Graphics.FONT_TINY, beat, Graphics.TEXT_JUSTIFY_RIGHT);
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawLine(200, 87, 235, 87); // horizontal line
	}
  	
  	function drawHeartRateGage(dc, beat) {
		var x = dc.getWidth() / 2, y = dc.getHeight() / 2;
  		
		var hrColor = Graphics.COLOR_BLUE;

		if (beat instanceof Number) {
			if (beat >= 90 && beat < 150) {
				hrColor = Graphics.COLOR_YELLOW;
			} else if (beat >= 150) {
				hrColor = Graphics.COLOR_RED;
				$.buzz();
				$.buzz();
			}
		}
		// Bar label
		var label = "BPM";
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth() - 25, (dc.getHeight() / 4) * 3, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_RIGHT);

		var level = (beat * 60) / MAX_HEART_RATE;

		var minDegrees = 330;
		var maxDegrees = 31;
		var levelDegrees = level <= 30 ? minDegrees + level : maxDegrees - (60 - level);
		levelDegrees = levelDegrees == minDegrees ? levelDegrees+1 : levelDegrees; // Add 1 otherwise it draws full circle

		// Gage notches
		dc.setPenWidth(5);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var val = 0;
		var valPosX = dc.getWidth() - 35, valPosY = 182;
		var nextDegrees = minDegrees;
		for (var i=0;i<5;i++) {
			// Notch
			dc.drawArc(x, y, x - 8, Graphics.ARC_COUNTER_CLOCKWISE, nextDegrees, nextDegrees + 1);
			nextDegrees += 15;

			// Label
			dc.drawText(valPosX, valPosY, $.FONT_XXTINY, val, Graphics.TEXT_JUSTIFY_RIGHT);
			valPosX += i < 2 ? 10 : -8;
			valPosY -= 29;
			val += MAX_HEART_RATE / 4;
		}

		// Gage bar
		dc.setPenWidth(3);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(x, y, x - 5, Graphics.ARC_COUNTER_CLOCKWISE, minDegrees, maxDegrees);
		dc.drawArc(x, y, x - 5, Graphics.ARC_COUNTER_CLOCKWISE, minDegrees, levelDegrees);
	}
  	
  	// function drawHeartRateVariability(dc, value) {
  	// 	var x = ( dc.getWidth() / 2 ) - 40, y = ROW_HEIGHT;
  		
  	// 	var label = "HRV";
		
	// 	var fColor = Graphics.COLOR_WHITE;
	// 	if (value instanceof Number) {
	// 		if (value < 40 || value > 75) {
	// 			fColor = Graphics.COLOR_RED;
	// 		} else if ((value >= 40 && value < 50) || (value > 60 && value <= 75)) {
	// 			fColor = Graphics.COLOR_YELLOW;
	// 		}
	// 	}
  		
    //     dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
    //     dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y + 10, $.FONT_TINY, value, Graphics.TEXT_JUSTIFY_CENTER);
  	// }
  	
	// Details: https://support.garmin.com/en-CA/?faq=F8YKCB4CJd5PG0DR9ICV3A
  	// function drawRestingHeartrate(dc, value) {
  	// 	var x = ( dc.getWidth() / 2 ), y = ROW_HEIGHT;
  		
  	// 	var label = "HR/day";

	// 	var fColor = Graphics.COLOR_WHITE;
	// 	if (value instanceof Number) {
	// 		if (value >= 65 && value < 75) {
	// 			fColor = Graphics.COLOR_YELLOW;
	// 			$.buzz();
	// 		} else if (value >= 75) {
	// 			fColor = Graphics.COLOR_RED;
	// 		}
	// 	}
  		
    //     dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
    //     dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y + 10, $.FONT_TINY, value, Graphics.TEXT_JUSTIFY_CENTER);
  	// }
}