using Toybox.Application.Storage;
using Toybox.WatchUi as Ui;

class Title extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Title" });
	}
	
	function draw(dc) {

		var appname = Ui.loadResource(Rez.Strings.Title);

        var x = dc.getWidth() / 2;
        var y = 26;

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_TINY, appname, Graphics.TEXT_JUSTIFY_CENTER);
  	}
}