using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Covid extends Ui.Drawable {

	var ROW_HEIGHT;

	function initialize() {
		Drawable.initialize({ :identifier => "Covid" });
	}
	
	function draw(dc) {
		ROW_HEIGHT = ( dc.getHeight() / 2 ) + 58;

		var x = ( $.SCREEN_X / 2), y = ROW_HEIGHT;
		var label = "COVID-19";
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		// var canada = "4268";
		var ontario = "-";
		if (Storage.getValue("covid19data_on")) {
			var data = Storage.getValue("covid19data_on");
			ontario = data["cases"]; // Today's cases
		}

		var ontarioDataPoints = [];
		if (Storage.getValue("covid19data_on_14days")) {
			ontarioDataPoints = Storage.getValue("covid19data_on_14days");
		}
		var toronto = "-";
		if (Storage.getValue("covid19data_tor")) {
			var data = Storage.getValue("covid19data_tor");
			toronto = data["cases"];
		}
		var yorkregion = "-";
		if (Storage.getValue("covid19data_york")) {
			var data = Storage.getValue("covid19data_york");
			yorkregion = data["cases"];
		}
		
		// drawCanada(dc, canada);
		drawOntario(dc, ontario);
		drawToronto(dc, toronto);
		drawYorkRegion(dc, yorkregion);
		drawTrendLine(dc, ontarioDataPoints);
  	}

	function drawOntario(dc, value) {
		var x = ( $.SCREEN_X / 2 ) - 60, y = ROW_HEIGHT;

		var label = "ON";

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 32, y + 16, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
	}

	function drawToronto(dc, value) {
		var x = ( $.SCREEN_X / 2 ) + 10, y = ROW_HEIGHT;

		var label = "TOR";

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 32, y + 16, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
	}

	function drawYorkRegion(dc, value) {
		var x = $.SCREEN_X - 45, y = ROW_HEIGHT;

		var label = "YORK";

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 35, y + 16, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
	}

	function drawTrendLine(dc, dataPoints) {
		if (dataPoints == null || dataPoints.size() < 1) {
			var x = $.SCREEN_X / 2, y = $.SCREEN_Y - 20;

			var value = "No data";

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y - 10, $.fontXTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
		} else {
			// Start point (upper left)
			var x = ( $.SCREEN_X / 2 ) - 50, y = $.SCREEN_Y - 25;


			var activeY = 0;
			var minY= 0, maxY = 1;
			for (var i=0; i < dataPoints.size(); i++) {
				if (i==0) {
					minY = dataPoints[i];
				} else {
					minY = dataPoints[i] < minY ? dataPoints[i] : minY;
				}
				maxY = dataPoints[i] > maxY ? dataPoints[i] : maxY;
			}

			var points = [];
			var offsetY = 0;

			for (var i=0; i < dataPoints.size(); i++) {

				if (i == 0) {
					activeY = y;
					offsetY = dataPoints[i];
				} else {
					var diff = dataPoints[i] - dataPoints[i-1]; // B - A

					// Determine Y coordinate for point
					var num = dataPoints[i] - offsetY;
					var dem = maxY - offsetY;
					var deltaY = 20 * (num.toFloat() / dem.toFloat());

					if (diff != 0) {
						var compression = 40.toFloat() / (maxY - minY).toFloat(); // 40 is the max height for this area
						activeY = y - (deltaY * compression);
					} else {
						// Keep it the same
					}
				}
				
				if (i > 0) {
					x += 15;
				}
				points.add([x, activeY.toNumber()]);
			}

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			for (var n = 0; n < points.size() - 1; n++) {
				var pointA = points[n];
				var pointB = points[n+1];
				dc.drawLine(pointA[0], pointA[1], pointB[0], pointB[1]);
			}
		}
		
	}
}