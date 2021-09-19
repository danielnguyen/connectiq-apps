using Toybox.Application.Storage;
using Toybox.WatchUi as Ui;

class Risk extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Risk" });
	}
	
	function draw(dc) {

		var app = Application.getApp();
		var showDrawable = app.getProperty("showLocation") == null ? true : app.getProperty("showLocation");

		if (showDrawable) {
			var bgData = Storage.getValue($.STORAGE_UV_DATA);

			var label = Ui.loadResource(Rez.Strings.text_risk);
			var value = "-";
			
			if (bgData != null && bgData["current_uv_data"] != null && bgData["forecast_uv_data"] != null ) {
				var uvValue = bgData["current_uv_data"]["uv"];
				if (uvValue instanceof Float || uvValue instanceof Number) {
					var sev = $.getUVSeverity(uvValue);
					value = sev["severity"];
				}
			}

			var x = dc.getWidth() / 6;
			var y = dc.getHeight() / 2;

			dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y - 15, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y, Graphics.FONT_SMALL, value, Graphics.TEXT_JUSTIFY_CENTER);
		}
  	}
}