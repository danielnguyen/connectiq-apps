using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.UserProfile;
using Toybox.WatchUi as Ui;

class Health extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Health" });
	}
	
	function draw(dc) {

		// Sensor and SensorInfo not available to WatchFace
		var activityInfo = Activity.getActivityInfo();
		var activityMonitorInfo = ActivityMonitor.getInfo();
		var userProfile = UserProfile.getProfile();

		var moveBarLevel = activityMonitorInfo.moveBarLevel;
		var steps = activityMonitorInfo.steps;
		var oxygenSaturation = activityInfo.currentOxygenSaturation;
		var avgRHR = userProfile.averageRestingHeartRate;
		
		// drawMoveBarLevel(dc, moveBarLevel, activityMonitorInfo.MOVE_BAR_LEVEL_MAX);
		drawSteps(dc, steps);
		drawSpo2(dc, oxygenSaturation);
		drawAverageRestingHeartRate(dc, avgRHR);
  	}
  	
  	// function drawRest(dc, value) {
  	// 	var x = 20, y = ROW_HEIGHT;
  		
  	// 	var label = "REST";
  		
    //     dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
    //     dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y + 10, $.FONT_TINY, value, Graphics.TEXT_JUSTIFY_CENTER);
  	// }
  	
  	// function drawBodyBatter(dc, value) {
  	// 	var x = ( dc.getWidth() / 2 ) - 75, y = ROW_HEIGHT;
  		
  	// 	var label = "BODY";
  		
    //     dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
    //     dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y + 10, $.FONT_TINY, value, Graphics.TEXT_JUSTIFY_CENTER);
  	// }
  	
  	// function drawMoveBarLevel(dc, value, max) {
  	// 	var x = 60, y = ROW_HEIGHT;
  		
  	// 	var label = "MOVE %";
		
	// 	var fColor = Graphics.COLOR_WHITE;
	// 	// if (value instanceof Number) {
	// 	// 	if (value < 40 || value > 75) {
	// 	// 		fColor = Graphics.COLOR_RED;
	// 	// 	} else if ((value >= 40 && value < 50) || (value > 60 && value <= 75)) {
	// 	// 		fColor = Graphics.COLOR_YELLOW;
	// 	// 	}
	// 	// }
  		
    //     dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(x, y, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_CENTER);

	// 	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
	// 	var progressBarWidth = 80;
	// 	var progressBarFill = progressBarWidth * ((max - value).toFloat() / max.toFloat()); // Reverse the value
	// 	dc.drawRoundedRectangle(x - 40, y + 15, progressBarWidth, 10, 10);
	// 	if (value == 0) {
	// 		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
	// 	}
	// 	dc.fillRoundedRectangle(x - 40, y + 15, progressBarFill.toNumber(), 10, 10);
  	// }
  	
  	function drawSteps(dc, value) {  		
  		var label = "STEPS";
		var steps = value != null && value instanceof Number ? value : 0;

		// Label
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(155, 185, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_RIGHT);
		// Value
		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(160, 185, Graphics.FONT_XTINY, steps, Graphics.TEXT_JUSTIFY_LEFT);
  	}

	function drawSpo2(dc, value) {
		var label = "SPO2";
		
		var color = Graphics.COLOR_BLUE;

		if (value == null) {
			value = "-";
		} else {
			value = value instanceof Number ? value : 0;

			// Value
			if (value > 85 && value <= 95) {
				color = Graphics.COLOR_YELLOW;
			} else if (value > 67 && value <= 85) {
				color = Graphics.COLOR_RED;
			} else if (value <= 67) {
				color = Graphics.COLOR_DK_RED;
			}
		}
		// Label
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(155, 170, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_RIGHT);

		dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		dc.drawText(160, 170, Graphics.FONT_XTINY, value + "%", Graphics.TEXT_JUSTIFY_LEFT);
	}

	function drawAverageRestingHeartRate(dc, value) {
		var label = "RHR";
		var avgRHR = value != null && value instanceof Number ? value : 0;

		// Label
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(155, 155, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_RIGHT);
		avgRHR = avgRHR == 0 ? "-" : avgRHR;
		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(160, 155, Graphics.FONT_XTINY, avgRHR + " BPM", Graphics.TEXT_JUSTIFY_LEFT);
	}

	// function drawGraph(dc) {
	// 	var point = [[40,40],[60,70],[80,40],[100,70],[120,50],[140,80],[160,40],[180,80]];
	// 	for (var i = 0;i<7;i++) {
	// 		var t = 0;
	// 		var y1;var y2;var y3;var y4;
	// 		for (var n = 0;n<10;n++) {
	// 			var half = (point[i+1][0] - point[i][0])/2.0;
	// 			var tmpy = Cal(point[i][1],point[i][1],point[i+1][1],point[i+1][1],t);
	// 			var tmpx = Cal(point[i][0],point[i][0]+half,point[i][0]+half,point[i+1][0],t);
	// 			dc.setColor(Graphics.COLOR_PINK, Graphics.COLOR_TRANSPARENT);
	// 			dc.drawPoint(tmpx,tmpy);
	// 			t = t + 0.1;
	// 		}
	// 	}
	// }

	// function Cal(y1,y2,y3,y4,t) {
	// 	var tmpy = y1*(1-t)*(1-t)*(1-t)
	// 	+3*y2*t*(1-t)*(1-t)
	// 	+3*y3*t*t*(1-t)
	// 	+y4*t*t*t;
	// 	return tmpy;
	// }
}