using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;
using Toybox.Weather;

class Weather extends Ui.Drawable {

	var POINT_OF_ORIGIN = [0, 0];

	function initialize() {
		Drawable.initialize({ :identifier => "Weather" });
	}
	
	function draw(dc) {
		POINT_OF_ORIGIN = [dc.getWidth() / 2, dc.getHeight() / 2];

		var currentWeather = Weather.getCurrentConditions();

		var uv = Storage.getValue("uv");
		var precipitation = currentWeather.precipitationChance;
		var temperature = currentWeather.temperature;
		
		drawUV(dc, uv);
		drawPrecipitation(dc, precipitation);
		drawTemperature(dc, temperature);
  	}
  	
  	function drawUV(dc, uv) {

  		var label = "UV";
		var fillColor = Graphics.COLOR_WHITE;
		if (uv == null) {
			uv = "-";
		} else {
			uv = uv instanceof Number ? uv : 0;

			if (uv >= 2 && uv < 6) {
				fillColor = Graphics.COLOR_YELLOW;
			} else if (uv >= 6 && uv < 8) {
				fillColor = Graphics.COLOR_ORANGE;
			} else if (uv >= 8 && uv < 11) {
				fillColor = Graphics.COLOR_RED;
			} else if (uv >= 11) {
				fillColor = Graphics.COLOR_PURPLE;
			} else {
				fillColor = Graphics.COLOR_BLUE;
			}

			uv = uv > 8 ? 8 : uv; // Limit to 8 as chances of extreme UV index low
			var length = (uv * 46) / 8;
				// Fill
			dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
			dc.fillRectangle(66, 81, length, 4);
		}

		// UV Bar
			// Label
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(60, 77, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_RIGHT);
			// Container
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawRectangle(65, 80, 50, 6);
			// Value
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth() / 2 - 10, 77, $.FONT_XXTINY, uv, Graphics.TEXT_JUSTIFY_LEFT);
  	}
  	
  	function drawPrecipitation(dc, precip) {

  		var label = "PCIP";
		var fillColor = Graphics.COLOR_BLUE;
		if (precip == null) {
			precip = "-";
		} else {
			precip = precip instanceof Number ? precip : 0;
			var length = (precip * 46) / 80;
				// Fill
			dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
			dc.fillRectangle(66, 91, length, 4);
		}
		
			// Label
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(60, 87, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_RIGHT);
			// Container
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawRectangle(65, 90, 50, 6);
			// Value
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth() / 2 - 10, 87, $.FONT_XXTINY, precip + "%", Graphics.TEXT_JUSTIFY_LEFT);
  	}
  	
  	function drawTemperature(dc, value) {

		value = value instanceof Number ? value : 0;
  		
  		var label = "TEMP";

		// Bar label
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(0, (dc.getHeight() / 2) - 25, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_LEFT);

		// Arc Temp
		var levels = 10;

		// Offset temp value up by 30 degrees
		var offsetTemp = ((value + 30) * 10) / 80;
		offsetTemp = offsetTemp instanceof Float ? offsetTemp.toNumber() : offsetTemp;

		var minDegrees = 165;
		var maxDegrees = 105;
		var notchWidth = (((minDegrees - maxDegrees) / levels) / 6);
		var notchSpace = notchWidth;
		var nextDegrees = minDegrees;
		dc.setPenWidth(10);
		var fillColor = Graphics.COLOR_WHITE;
		for (var i=0;i<levels;i++) {
			if (i < 3) {
				fillColor = $.COLOR_LT_BLUE;
			} else if (i >= 3 && i < 5) {
				fillColor = Graphics.COLOR_BLUE;
			} else if (i >= 5 && i < 7) {
				fillColor = Graphics.COLOR_YELLOW;
			} else if (i >= 7 && i < 8) {
				fillColor = Graphics.COLOR_ORANGE;
			} else if (i >= 8) {
				fillColor = Graphics.COLOR_RED;
			}
			var notchColor = (i == offsetTemp) || (i < 3 && i > offsetTemp) || (i >= 3 && i < offsetTemp) ? fillColor : Graphics.COLOR_DK_GRAY;
			dc.setColor(notchColor, Graphics.COLOR_TRANSPARENT);
			dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 5, Graphics.ARC_CLOCKWISE, nextDegrees, nextDegrees - notchWidth);
			nextDegrees -= (notchWidth + notchSpace);
			dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 5, Graphics.ARC_CLOCKWISE, nextDegrees, nextDegrees - notchWidth);
			nextDegrees -= (notchWidth + notchSpace);
		}

		// Bar guide
		dc.setPenWidth(2);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 15, Graphics.ARC_CLOCKWISE, minDegrees, minDegrees - 10);
		dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], POINT_OF_ORIGIN[0] - 15, Graphics.ARC_CLOCKWISE, minDegrees - 17, minDegrees - 39);

		// Bar value
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawText(25, 70, $.FONT_XXTINY, "0", Graphics.TEXT_JUSTIFY_LEFT);

		// Value
		dc.setPenWidth(1);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(65, 50, Graphics.FONT_TINY, value + "c", Graphics.TEXT_JUSTIFY_LEFT);
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawLine(40, 60, 60, 60); // horizontal line
  	}
}