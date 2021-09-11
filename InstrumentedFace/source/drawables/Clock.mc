using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Clock extends Ui.Drawable {

	function initialize() {
		Drawable.initialize({ :identifier => "Clock" });
	}
	
	function draw(dc) {
		var clockTime = System.getClockTime();
		var is24Hour = System.getDeviceSettings().is24Hour;
		
		drawTime(dc, clockTime, is24Hour);
		if (!is24Hour) {		
			drawAMPM(dc, clockTime);
		}
  	}
  	
  	function drawTime(dc, clockTime, is24Hour) {
        // $.logMessage("Clock::drawTime ENTER");
		var x = $.SCREEN_X / 2, y = ( $.SCREEN_Y / 2 ) - 50;

  		var hours = clockTime.hour;
  		hours = !is24Hour && hours > 12 ? hours - 12 : hours;
        var time = Lang.format("$1$:$2$", [hours.format("%02d"), clockTime.min.format("%02d")]);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(x, y, $.fontXLarge, time, Graphics.TEXT_JUSTIFY_CENTER);  	
        // $.logMessage("Clock::drawTime EXIT");
  	} 
  	
  	function drawAMPM(dc, clockTime) {
        // $.logMessage("Clock::drawAMPM ENTER");		
  		// var x = ( $.SCREEN_X ) - 35, y = ( $.SCREEN_Y / 2 ) - 13;
		var x = $.SCREEN_X - 40, y = $.SCREEN_Y / 2 - 25;
  		
  		var text = clockTime.hour > 12 ? "PM" : "AM";
  		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontSmall, text, Graphics.TEXT_JUSTIFY_LEFT);
        // $.logMessage("Clock::drawAMPM EXIT");		
  	}
}