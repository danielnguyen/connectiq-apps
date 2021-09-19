using Toybox.Application.Storage;
using Toybox.WatchUi as Ui;

class Message extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Message" });
	}
	
	function draw(dc) {
		var bgData = Storage.getValue($.STORAGE_UV_DATA);

		var app = Application.getApp();
		var storedMessage = app.getProperty("message");
		var showExposureTime = app.getProperty("showExposureTime") == null ? true : app.getProperty("showExposureTime");

		var message = "No data";

		if (bgData != null && bgData["current_uv_data"] != null && bgData["forecast_uv_data"] != null ) {
			if (showExposureTime) {
				var uvExposureMins = bgData["current_uv_data"]["safe_exposure_time"]["st1"];
				if (uvExposureMins instanceof Number) {
					var uvExposureHours = uvExposureMins.toFloat() / 60.0;
					message = "Safe exposure time: " + uvExposureHours.format("%.1f") + " hours";
				} else {
					message = "You are currently safe";
				}
			} else {
				message = "";
			}
		} else if (storedMessage != null && storedMessage.length() > 0) {
			message = storedMessage;
		} 

        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 4;

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, message, Graphics.TEXT_JUSTIFY_CENTER);
  	}
}