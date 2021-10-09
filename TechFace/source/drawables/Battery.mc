using Toybox.Attention;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Battery extends Ui.Drawable {

	var POINT_OF_ORIGIN = [0, 0];

	function initialize() {
		Drawable.initialize({ :identifier => "Battery" });
	}
	
	function draw(dc) {
		POINT_OF_ORIGIN = [dc.getWidth() / 2, dc.getHeight() / 2];

		var systemStats = System.getSystemStats();
		var battery = systemStats.battery != null ? systemStats.battery.toNumber() : 0;

		drawBatteryNotch(dc, battery, systemStats.charging);
  	}

	function drawBatteryNotch(dc, value, isCharging) {

		var label = isCharging ? "CHRG" : "BATT";
		var batteryLevel = value / 10; // Base 10

		// Bar label
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(0, (dc.getHeight() / 2) + 5, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_LEFT);

		// Arc
		var levels = 10;

		var minDegrees = 230;
		var maxDegrees = 170;
		var notchWidth = (((minDegrees - maxDegrees) / levels) / 6);
		var notchSpace = notchWidth;
		var nextDegrees = minDegrees;
		dc.setPenWidth(10);
		var fillColor = Graphics.COLOR_BLUE;
		for (var i=0;i<levels;i++) {
			if (isCharging) {
				fillColor = $.COLOR_GREEN;
			} else if (value <= 10) {
				fillColor = Graphics.COLOR_RED;
				// $.ring(Attention.TONE_LOW_BATTERY);
			} else if (value > 10 && value <= 20) {
				fillColor = Graphics.COLOR_ORANGE;
			} else if (value > 20 && value <= 30) {
				fillColor = Graphics.COLOR_YELLOW;
			}
			var notchColor = i < batteryLevel ? fillColor : Graphics.COLOR_DK_GRAY;
			dc.setColor(notchColor, Graphics.COLOR_TRANSPARENT);
			dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 5, Graphics.ARC_CLOCKWISE, nextDegrees, nextDegrees - notchWidth);
			nextDegrees -= (notchWidth + notchSpace);
			dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 5, Graphics.ARC_CLOCKWISE, nextDegrees, nextDegrees - notchWidth);
			nextDegrees -= (notchWidth + notchSpace);
		}

		// Bar guide
		dc.setPenWidth(2);
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 15, Graphics.ARC_CLOCKWISE, minDegrees - 5, minDegrees - 10);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 15, Graphics.ARC_CLOCKWISE, minDegrees - 17, minDegrees - 35);

		// Bar value
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawText(50, 210, $.FONT_XXTINY, 0, Graphics.TEXT_JUSTIFY_LEFT);
		dc.drawText(35, 192, $.FONT_XXTINY, 30, Graphics.TEXT_JUSTIFY_LEFT);
		dc.drawText(15, 148, $.FONT_XXTINY, 100, Graphics.TEXT_JUSTIFY_LEFT);

		// Value
		dc.setPenWidth(1);
		var text = "-";
		if (isCharging) {
			dc.setColor($.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
			text = "CHRG";
		} else {
			var color = value <= 10 ? Graphics.COLOR_RED : Graphics.COLOR_WHITE;
			dc.setColor(color, Graphics.COLOR_TRANSPARENT);
			text = value + "%";
		}
		dc.drawText(55, 172, Graphics.FONT_TINY, text, Graphics.TEXT_JUSTIFY_LEFT);
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawLine(25, 182, 50, 182); // horizontal line
	}
  	
  	function drawBatteryGage(dc, value, isCharging) {
		var x = dc.getWidth() / 2, y = dc.getHeight() / 2;
  		
		var bColor = Graphics.COLOR_BLUE;
		var label = "BATT";

		if (value <= 10) {
			bColor = Graphics.COLOR_RED;
			$.ring(Attention.TONE_LOW_BATTERY);
		} else if (value > 10 && value <= 20) {
			bColor = Graphics.COLOR_ORANGE;
		} else if (value > 20 && value <= 30) {
			bColor = Graphics.COLOR_YELLOW;
		}

		var level = (value * 60) / 100;

		if (isCharging) {
			bColor = $.COLOR_GREEN;
			label = "CHRG";
		}

		// Bar label
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(25, (dc.getHeight() / 4) * 3, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_LEFT);

		var minDegrees = 210;
		var maxDegrees = 151;
		var levelDegrees = minDegrees - level;
		levelDegrees = levelDegrees == minDegrees ? levelDegrees+1 : levelDegrees; // Add 1 otherwise it draws full circle

		// Gage notches
		dc.setPenWidth(5);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var val = 0;
		var valPosX = 35, valPosY = 182;
		var nextDegrees = minDegrees;
		for (var i=0;i<5;i++) {
			// Notch
			dc.drawArc(x, y, x - 8, Graphics.ARC_COUNTER_CLOCKWISE, nextDegrees, nextDegrees + 1);
			nextDegrees -= 15;

			// Label
			dc.drawText(valPosX, valPosY, $.FONT_XXTINY, val, Graphics.TEXT_JUSTIFY_LEFT);
			valPosX += i < 2 ? -10 : 8;
			valPosY -= 28;
			val += 25;
		}

		// Gage bar
		dc.setPenWidth(3);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(x, y, x - 5, Graphics.ARC_CLOCKWISE, minDegrees, maxDegrees);
  		
        dc.setColor(bColor, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(x, y, x - 5, Graphics.ARC_CLOCKWISE, minDegrees, levelDegrees);
  	}
}