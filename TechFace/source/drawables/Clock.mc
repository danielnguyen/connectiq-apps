using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Clock extends Ui.Drawable {

	private var POINT_OF_ORIGIN = [0,0];

	function initialize() {
		Drawable.initialize({ :identifier => "Clock" });
	}
	
	function draw(dc) {

		// POINT_OF_ORIGIN = [(dc.getWidth() / 2) - 10, (dc.getHeight() / 2) - 48];
		POINT_OF_ORIGIN = [(dc.getWidth() / 2), (dc.getHeight() / 2) - 30];

		var clockTime = System.getClockTime();
		var is24Hour = System.getDeviceSettings().is24Hour || Application.getApp().getProperty("UseMilitaryFormat");
		
		drawTime(dc, clockTime, is24Hour);
		if (!is24Hour) {		
			drawAMPM(dc, clockTime);
		}
  	}
  	
  	function drawTime(dc, clockTime, is24Hour) {
  		var hours = clockTime.hour;
  		hours = !is24Hour && hours > 12 ? hours - 12 : hours;
        var time = Lang.format("$1$:$2$", [hours.format("%02d"), clockTime.min.format("%02d")]);
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(POINT_OF_ORIGIN[0], POINT_OF_ORIGIN[1], Graphics.FONT_NUMBER_MEDIUM, time, Graphics.TEXT_JUSTIFY_CENTER);  	
  	} 
  	
  	function drawAMPM(dc, clockTime) {  		
  		var text = getAMPM(clockTime);
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(POINT_OF_ORIGIN[0] + 55, POINT_OF_ORIGIN[1] + 20, Graphics.FONT_SMALL, text, Graphics.TEXT_JUSTIFY_LEFT);
  	}

	private function getAMPM(clockTime) {
		return clockTime.hour > 12 ? "PM" : "AM";
	}
}