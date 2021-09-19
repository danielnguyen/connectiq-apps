using Toybox.Application.Storage;
using Toybox.WatchUi as Ui;

class Max extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Max" });
	}
	
	function draw(dc) {

		var app = Application.getApp();
		var showDrawable = app.getProperty("showLocation") == null ? true : app.getProperty("showLocation");

		if (showDrawable) {
			
			var bgData = Storage.getValue($.STORAGE_UV_DATA);

			var label = Ui.loadResource(Rez.Strings.text_max);
			var value = "-";
			
			if (bgData != null && bgData["current_uv_data"] != null && bgData["forecast_uv_data"] != null ) {
				var uvMaxValue = bgData["current_uv_data"]["uv_max"];
				if (uvMaxValue instanceof Float || uvMaxValue instanceof Number) {
					value = uvMaxValue.format("%.1f");
				}
			}

			var x = dc.getWidth() - (dc.getWidth() / 6);
			var y = dc.getHeight() / 2;

			dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y - 15, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y, Graphics.FONT_SMALL, value, Graphics.TEXT_JUSTIFY_CENTER);
		}
  	}
}