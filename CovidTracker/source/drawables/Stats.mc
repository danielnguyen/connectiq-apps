using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Stats extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Stats" });
	}
	
	function draw(dc) {
		var ontarioDataPoints = [];
		if (Storage.getValue("covid19data_14days")) {
			ontarioDataPoints = Storage.getValue("covid19data_14days");
		}
        
		drawStats(dc, ontarioDataPoints);
  	}

	function drawStats(dc, dataPoints) {
		var x = $.SCREEN_X / 2, y = $.SCREEN_Y / 2;
		if (dataPoints == null || dataPoints.size() < 1) {

			var value = "No data";

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y - 10, $.fontXTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
		} else {
			// Determine min/max of results
			var minMax = getMinMax(dataPoints);

			var stat1Label = "24H AGO";
			var stat2Label = "TODAY";
			var stat3Label = "7-DAY AVG CHANGE";

			// Stat 1
			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(45, y + 46, $.fontXTiny, stat1Label, Graphics.TEXT_JUSTIFY_CENTER);

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText($.SCREEN_X / 2 - 27, y + 40, $.fontTiny, dataPoints[dataPoints.size() - 2], Graphics.TEXT_JUSTIFY_CENTER);

			// Stat 2
			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
			dc.drawText($.SCREEN_X / 2 + 35, y + 46, $.fontXTiny, stat2Label, Graphics.TEXT_JUSTIFY_CENTER);

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText($.SCREEN_X - 45, y + 40, $.fontTiny, dataPoints[dataPoints.size() - 1], Graphics.TEXT_JUSTIFY_CENTER);

			// Stat 3
			var diff = (dataPoints[dataPoints.size() - 1].toFloat() - dataPoints[dataPoints.size() - 2].toFloat()) / minMax[1].toFloat(); // dataPoints[0].toFloat()) / minMax[1].toFloat();
			var changeValue = diff > 0 ? "+" : "";
			changeValue += (diff * 100).format("%.2f") + "%";

			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
			dc.drawText($.SCREEN_X / 2, $.SCREEN_X - 50, $.fontXTiny, stat3Label, Graphics.TEXT_JUSTIFY_CENTER);

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText($.SCREEN_X / 2, $.SCREEN_X - 35, $.fontTiny, changeValue, Graphics.TEXT_JUSTIFY_CENTER);
		}
	}

	private function getDataPointCoords(dataPoints, xDistance, offset) {
		var pointInterval = xDistance != null ? xDistance : 30;
		// Start point
		var x = ($.SCREEN_X - ((dataPoints.size() - 1) * pointInterval)) / 2, y = $.SCREEN_Y / 2;

		var activeY = 0;

		// Determine min/max of results
		var minMax = getMinMax(dataPoints);
		var minY = minMax[0], maxY = minMax[1];

		var points = [];
		var offsetY = offset != null ? offset : 50;

		for (var i=0; i < dataPoints.size(); i++) {

			var diff = dataPoints[i] - minY;

			// Determine Y coordinate for point
			var deltaY = diff * 100 / (maxY - minY);
			var relMid = ((maxY - minY) / 2) + minY;

			if (dataPoints[i] > relMid) {
				activeY = y - (deltaY / 2);
			} else if (dataPoints[i] < relMid) {
				activeY = y + (deltaY / 2);
			} else {
				// Keep it the same
			}
			
			// Set X
			if (i > 0) {
				x += pointInterval;
			}
			// Offset Y
			activeY += offsetY;

			points.add([x, activeY.toNumber()]);
		}
		return points;
	}

	private function getMinMax(dataPoints) {
		var minY= 0, maxY = 1;
		for (var i=0; i < dataPoints.size(); i++) {
			if (i==0) {
				minY = dataPoints[i];
			} else {
				minY = dataPoints[i] < minY ? dataPoints[i] : minY;
			}
			maxY = dataPoints[i] > maxY ? dataPoints[i] : maxY;
		}
		return [minY, maxY];
	}
}