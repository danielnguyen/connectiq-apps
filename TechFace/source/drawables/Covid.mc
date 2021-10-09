using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Covid extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Covid" });
	}
	
	function draw(dc) {
		var x = (dc.getWidth() / 2), y = dc.getHeight() - 50;
		var label = "COVID-19";
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(x, y, $.FONT_XXTINY, label, Graphics.TEXT_JUSTIFY_CENTER);

		var dataPoints = [];
		if (Storage.getValue("covid19data_14days")) {
			dataPoints = Storage.getValue("covid19data_14days");
		}

		drawBarGraph(dc, dataPoints);
  	}

	function drawBarGraph(dc, dataPoints) {
		var x = dc.getWidth()/ 2, y = dc.getHeight() - 10;
		if (dataPoints == null || dataPoints.size() < 1) {

			var value = "No data";

			dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y - 10, $.FONT_XXTINY, value, Graphics.TEXT_JUSTIFY_CENTER);
		} else {
			var points = getDataPointCoords(dc, dataPoints, 8, 30, 5);

			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
			for (var n = 0; n < points.size(); n++) {
				var point = points[n];

				dc.setPenWidth(3);
				dc.drawLine(point[0], point[1], point[0], y + 10);
				dc.setPenWidth(1);
			}
		}
	}

	private function getDataPointCoords(dc, dataPoints, xDistance, yDistance, offset) {
		var pointInterval = xDistance != null ? xDistance : 30;
		// Start point
		var x = (dc.getWidth() - ((dataPoints.size() - 1) * pointInterval)) / 2, y = dc.getHeight() - 20;

		var activeY = 0;

		// Determine min/max of results
		var minMax = getMinMax(dataPoints);
		var minY = minMax[0], maxY = minMax[1];

		var points = [];
		var offsetY = offset != null ? offset : 50;

		for (var i=0; i < dataPoints.size(); i++) {

			var diff = dataPoints[i] - minY;

			// Determine Y coordinate for point
			var deltaY = diff * yDistance / (maxY - minY);
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