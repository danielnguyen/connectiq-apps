using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Trend extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Trend" });
	}
	
	function draw(dc) {

		// var x = ( $.SCREEN_X / 2), y = ( $.SCREEN_Y / 2) + 65;
		// var label = "DAILY";
		// dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		// dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		var ontario = "-";
		if (Storage.getValue("covid19data")) {
			var data = Storage.getValue("covid19data");
			ontario = data["cases"]; // Today's cases
		}

		var ontarioDataPoints = [];
		if (Storage.getValue("covid19data_14days")) {
			ontarioDataPoints = Storage.getValue("covid19data_14days");
		}
		// var toronto = "-";
		// if (Storage.getValue("covid19data_tor")) {
		// 	var data = Storage.getValue("covid19data_tor");
		// 	toronto = data["cases"];
		// }
		// var yorkregion = "-";
		// if (Storage.getValue("covid19data_york")) {
		// 	var data = Storage.getValue("covid19data_york");
		// 	yorkregion = data["cases"];
		// }

		// drawToronto(dc, toronto);
		// drawYorkRegion(dc, yorkregion);
		// drawTrendLine(dc, ontarioDataPoints);
		drawBarGraph(dc, ontarioDataPoints);
  	}

	function drawOntario(dc, value) {
		var x = ( $.SCREEN_X / 2 ) - 60, y = 70;

		var label = "ON";

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 32, y + 16, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
	}

	function drawToronto(dc, value) {
		var x = ( $.SCREEN_X / 2 ) - 25, y = ( $.SCREEN_X / 2 ) + 70;

		var label = "TOR";

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 32, y + 16, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
	}

	function drawYorkRegion(dc, value) {
		var x = ( $.SCREEN_X / 2 ) + 55, y = ( $.SCREEN_X / 2 ) + 70;

		var label = "YORK";

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 35, y + 16, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
	}

	function drawTrendLine(dc, dataPoints) {
		if (dataPoints == null || dataPoints.size() < 1) {
			var x = $.SCREEN_X / 2, y = $.SCREEN_Y / 2;

			var value = "No data";

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y - 10, $.fontXTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
		} else {
			var points = getDataPointCoords(dataPoints, 30, 50);

			// Add leading and training points
			// var margin = 30;
			// if (points.size() == 0) {
			// 	points.add([20, $.SCREEN_Y / 2]);
			// 	points.add([$.SCREEN_X - margin, $.SCREEN_Y / 2]);
			// } else {
			// 	points.add([$.SCREEN_X - margin - 40, $.SCREEN_Y / 2]);
			// 	points.add([$.SCREEN_X - margin, $.SCREEN_Y / 2]);
			// 	points = points.reverse();
			// 	points.add([margin + 50, $.SCREEN_Y / 2]);
			// 	points.add([margin, $.SCREEN_Y / 2]);
			// 	points = points.reverse();
			// }

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			for (var n = 0; n < points.size() - 1; n++) {
				var pointA = points[n];
				var pointB = points[n+1];

				dc.setPenWidth(5);
				dc.drawLine(pointA[0], pointA[1], pointB[0], pointB[1]);
			}
		}
		
	}

	function drawBarGraph(dc, dataPoints) {
		var x = $.SCREEN_X / 2, y = $.SCREEN_Y / 2;
		if (dataPoints == null || dataPoints.size() < 1) {

			var value = "No data";

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y - 10, $.fontXTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
		} else {
			var points = getDataPointCoords(dataPoints, 22, 0);

			var graphLineY = y + 40;
			
			for (var n = 0; n < points.size(); n++) {
				var point = points[n];

				var offsetX = -8;
				var offsetY = 0;
				dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
				if (n < points.size() - 1) { // Highlight last column
					dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
				}
				// dc.drawRoundedRectangle(point[0] + offsetX, point[1] + offsetY, 10, graphLineY - point[1] - offsetY, 1);
				dc.fillRoundedRectangle(point[0] + offsetX, point[1] + offsetY, 15, graphLineY - point[1] - offsetY, 1);
			}

			// Draw X-axis line
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawLine(x - 90, graphLineY - 1, x + 90, graphLineY - 1);
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