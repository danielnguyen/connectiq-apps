using Toybox.Application.Storage;
using Toybox.WatchUi as Ui;

class Current extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Current" });
	}
	
	function draw(dc) {
		var bgData = Storage.getValue($.STORAGE_UV_DATA);

		var value = "-";
		
		if (bgData != null && bgData["current_uv_data"] != null && bgData["forecast_uv_data"] != null ) {
			var uvValue = bgData["current_uv_data"]["uv"];
            if (uvValue instanceof Float || uvValue instanceof Number) {
                value = uvValue.format("%.1f");
            }
		}

		var x = dc.getWidth() / 2;
		var y = (dc.getHeight() / 2) - 50;

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
}