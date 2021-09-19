using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.WatchUi as Ui;

class Location extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Location" });
	}
	
	function draw(dc) {

		var app = Application.getApp();
		var showDrawable = app.getProperty("showLocation") == null ? true : app.getProperty("showLocation");

		if (showDrawable) {
			var bgData = Storage.getValue($.STORAGE_UV_DATA);

			var value = "-";
			
			if (bgData != null && bgData["current_uv_data"] != null && bgData["forecast_uv_data"] != null ) {
				var locationData = bgData["location_data"];
				if (locationData != null) {
					var location = locationData["country"];
					if (locationData["village"] != null) {
						location = locationData["village"] + ", " + location;
					} else if (locationData["municipality"] != null) {
						location = locationData["municipality"] + ", " + location;
					} else if (locationData["city"] != null) {
						location = locationData["city"] + ", " + location;
					}
					value = location;
				}
			}

			var x = dc.getWidth() / 2;
			var y = dc.getHeight() - (dc.getHeight() / 3);

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_CENTER);
		}
		
	}
}