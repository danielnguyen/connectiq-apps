using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Date extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Date" });
	}
	
	function draw(dc) {
		var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

		drawDate(dc, today.day);
		drawSeparator(dc);
		drawDay(dc, today.day_of_week.toUpper());
		drawMonth(dc, today.month.toUpper());
		drawYear(dc, today.year);
  	}
  	
  	function drawDay(dc, value) {
		var x = dc.getWidth() / 2 - 22, y = 0;
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_LEFT);
  	}
  	
  	function drawDate(dc, value) {
		var x = 98, y = 15;
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.FONT_NORMAL, value, Graphics.TEXT_JUSTIFY_RIGHT);
  	}
  	
  	function drawMonth(dc, value) {
		var x = dc.getWidth() / 2 - 22, y = 20;
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_LEFT);
  	}
  	
  	function drawYear(dc, value) {
        var x = (dc.getWidth() / 3 * 2) - 35, y = 20;
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_LEFT);
  	}
  	
  	function drawSeparator(dc) {
		dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(105, 0, 105, 40);
  	}
}