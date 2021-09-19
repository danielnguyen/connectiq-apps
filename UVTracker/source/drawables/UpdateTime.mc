using Toybox.WatchUi as Ui;

class UpdateTime extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "UpdateTime" });
	}
	
	function draw(dc) {

		var app = Application.getApp();
		var showDrawable = app.getProperty("showLocation") == null ? true : app.getProperty("showLocation");

		if (showDrawable) {
			var label = Ui.loadResource(Rez.Strings.text_updated);
			var value = $.getTime();

			var x = dc.getWidth() / 2;
			var y = dc.getHeight() - (dc.getHeight() / 8);

			dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y - 15, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);

			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_CENTER);
		}
  	}
}