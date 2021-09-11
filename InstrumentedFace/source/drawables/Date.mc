using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Date extends Ui.Drawable {

	var ROW_HEIGHT = 48;

	function initialize() {
		Drawable.initialize({ :identifier => "Date" });
	}
	
	function draw(dc) {
		var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		
		drawDay(dc, today.day_of_week.substring(0, 3).toUpper());
		drawDate(dc, today.day);
		drawMonth(dc, today.month.substring(0, 3).toUpper());
		drawYear(dc, today.year);
  	}
  	
  	function drawDay(dc, value) {
  		var x = 55, y = ROW_HEIGHT;
  		
  		var label = "DAY";
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawDate(dc, value) {
  		var x = ( $.SCREEN_X / 2 ) - 30, y = ROW_HEIGHT;
  		
  		var label = "DATE";
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawMonth(dc, value) {
  		var x = ( $.SCREEN_X / 2 ) + 20, y = ROW_HEIGHT;
  		
  		var label = "MONTH";
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawYear(dc, value) {
  		var x = $.SCREEN_X - 55, y = ROW_HEIGHT;
  		
  		var label = "YEAR";
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
}