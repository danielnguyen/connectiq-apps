using Toybox.Application.Storage;
using Toybox.WatchUi as Ui;

class Ring extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Ring" });
	}
	
	function draw(dc) {

		var app = Application.getApp();
		var showDrawable = app.getProperty("showLocation") == null ? true : app.getProperty("showLocation");

		if (showDrawable) {
			var bgData = Storage.getValue($.STORAGE_UV_DATA);
			var timeDegree = 0;

			// Arc width
			dc.setPenWidth( 8 );

			// Arc - No UV
			drawUVArc(dc, Graphics.COLOR_BLUE, 1, 0, 360);

			if (bgData != null && bgData["current_uv_data"] != null && bgData["forecast_uv_data"] != null ) {

				// If time between 6AM and 6PM, show UV arcs
				var systemTime = System.getClockTime();
				if ( $.DEV_MODE || (systemTime.hour > 6 && systemTime.hour < 18)) {

					var uvForecast = bgData["forecast_uv_data"];
					for (var i = 0; i < uvForecast.size(); i++) {
						var segment = uvForecast[i];
						var color = $.getUVSeverityColor(segment["severity"]);
						var startDegrees = $.convertTimeToDegrees($.getMomentByTimeString(segment["startDate"]));
						var endDegrees = $.convertTimeToDegrees($.getMomentByTimeString(segment["endDate"]));
						drawUVArc(dc, color, 2, startDegrees, endDegrees);
					}

					// Arc - Max UV
					// if (bgData["current_uv_data"]["uv_max_time"] != null) {
					//     timeDegree = $.convertTimeToDegrees($.getMomentByTimeString(bgData["current_uv_data"]["uv_max_time"]));
					//     drawUVArc(dc, Graphics.COLOR_DK_RED, 2, timeDegree + 15, timeDegree - 15);
					// }
				}

				// Clock
				timeDegree = $.convertTimeToDegrees(Time.now());
				drawUVArc(dc, Graphics.COLOR_BLACK, 3, timeDegree + 3, timeDegree - 3);
				drawUVArc(dc, Graphics.COLOR_WHITE, 3, timeDegree + 1, timeDegree - 1);
				
			}
		}
		
  	}

	function drawUVArc(dc as DC, color, radiusOffset, degreeStart, degreeEnd) {

		var CENTER_X = dc.getWidth() / 2;
		var CENTER_Y = dc.getHeight() / 2;

		dc.setColor( color, Graphics.COLOR_BLACK );
		dc.drawArc( CENTER_X, CENTER_Y, CENTER_X - radiusOffset, Graphics.ARC_CLOCKWISE, degreeStart, degreeEnd );
	}
}