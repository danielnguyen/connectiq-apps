using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.UserProfile;
using Toybox.WatchUi as Ui;

class Health extends Ui.Drawable {

	var ROW_HEIGHT;

	function initialize() {
		Drawable.initialize({ :identifier => "Health" });
	}
	
	function draw(dc) {

		ROW_HEIGHT = ( dc.getHeight() / 2 ) + 22;

		// Sensor and SensorInfo not available to WatchFace
		var activityInfo = Activity.getActivityInfo();
		var activityMonitorInfo = ActivityMonitor.getInfo();
		var userProfile = UserProfile.getProfile();

		var moveBarLevel = activityMonitorInfo.moveBarLevel != null ? activityMonitorInfo.moveBarLevel : "-";
		var avgHR = userProfile.restingHeartRate != null ? userProfile.restingHeartRate : "-";
		var currHR = activityInfo.currentHeartRate != null ? activityInfo.currentHeartRate : "-";
		var steps = activityMonitorInfo.steps != null ? activityMonitorInfo.steps : 0;
		
		drawMoveBarLevel(dc, moveBarLevel, activityMonitorInfo.MOVE_BAR_LEVEL_MAX);
		// drawHeartRateVariability(dc, hrv);
		drawRestingHeartrate(dc, avgHR);
		drawCurrentHeartrate(dc, currHR);
		drawSteps(dc, steps);
		
  	}
  	
  	function drawRest(dc, value) {
  		var x = 20, y = ROW_HEIGHT;
  		
  		var label = "REST";
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawBodyBatter(dc, value) {
  		var x = ( $.SCREEN_X / 2 ) - 75, y = ROW_HEIGHT;
  		
  		var label = "BODY";
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawBPM(dc, value) {
  		var x = ( $.SCREEN_X / 2 ) - 40, y = ROW_HEIGHT;
  		
  		var label = "BRPM";
		
		var fColor = Graphics.COLOR_WHITE;
		if (value < 12) {
			fColor = Graphics.COLOR_YELLOW;
		} 
		if (value > 16) {
			fColor = Graphics.COLOR_YELLOW;
		} 
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawMoveBarLevel(dc, value, max) {
  		var x = 60, y = ROW_HEIGHT;
  		
  		var label = "MOVE %";
		
		var fColor = Graphics.COLOR_WHITE;
		// if (value instanceof Number) {
		// 	if (value < 40 || value > 75) {
		// 		fColor = Graphics.COLOR_RED;
		// 	} else if ((value >= 40 && value < 50) || (value > 60 && value <= 75)) {
		// 		fColor = Graphics.COLOR_YELLOW;
		// 	}
		// }
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var progressBarWidth = 80;
		var progressBarFill = progressBarWidth * (value.toFloat() / max.toFloat());
		dc.drawRoundedRectangle(x - 40, y + 15, progressBarWidth, 10, 10);
		dc.fillRoundedRectangle(x - 40, y + 15, progressBarFill.toNumber(), 10, 10);
  	}
  	
  	function drawHeartRateVariability(dc, value) {
  		var x = ( $.SCREEN_X / 2 ) - 40, y = ROW_HEIGHT;
  		
  		var label = "HRV";
		
		var fColor = Graphics.COLOR_WHITE;
		if (value instanceof Number) {
			if (value < 40 || value > 75) {
				fColor = Graphics.COLOR_RED;
			} else if ((value >= 40 && value < 50) || (value > 60 && value <= 75)) {
				fColor = Graphics.COLOR_YELLOW;
			}
		}
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
	// Details: https://support.garmin.com/en-CA/?faq=F8YKCB4CJd5PG0DR9ICV3A
  	function drawRestingHeartrate(dc, value) {
  		var x = ( $.SCREEN_X / 2 ), y = ROW_HEIGHT;
  		
  		var label = "HR/day";

		var fColor = Graphics.COLOR_WHITE;
		if (value instanceof Number) {
			if (value >= 65 && value < 75) {
				fColor = Graphics.COLOR_YELLOW;
				$.buzz();
			} else if (value >= 75) {
				fColor = Graphics.COLOR_RED;
			}
		}
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawCurrentHeartrate(dc, value) {
  		var x = ( $.SCREEN_X / 2 ) + 40, y = ROW_HEIGHT;
  		
  		var label = "HR";

		var fColor = Graphics.COLOR_WHITE;
		if (value instanceof Number) {
			if (value >= 90 && value < 150) {
				fColor = Graphics.COLOR_YELLOW;
			} else if (value >= 150) {
				fColor = Graphics.COLOR_RED;
				$.buzz();
				$.buzz();
			}
		}
		
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawSteps(dc, value) {
  		var x = $.SCREEN_X - 40, y = ROW_HEIGHT;
  		
  		var label = "STEPS";
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
}