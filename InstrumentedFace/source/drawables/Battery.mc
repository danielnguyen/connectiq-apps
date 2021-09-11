using Toybox.Attention;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class Battery extends Ui.Drawable {

	var ROW_HEIGHT = 0;

	function initialize() {
		Drawable.initialize({ :identifier => "Battery" });
	}
	
	function draw(dc) {

		var systemStats = System.getSystemStats();
		var battery = systemStats.battery != null ? systemStats.battery.toNumber() : 0;

		drawBattery(dc, battery, systemStats.charging);
  	}
  	
  	function drawBattery(dc, value, isCharging) {
		var x = 22, y = $.SCREEN_Y / 2 - 25;
  		
  		var label = "BATT";

		var fColor = Graphics.COLOR_WHITE;
		var fSize = $.fontTiny;

		if (value <= 10) {
			fColor = Graphics.COLOR_RED;
			$.ring(Attention.TONE_LOW_BATTERY);
		} else if (value > 10 && value <= 20) {
			fColor = Graphics.COLOR_ORANGE;
		} else if (value > 20 && value <= 30) {
			fColor = Graphics.COLOR_YELLOW;
		}

		if (isCharging) {
			value = "CHRG";
			fColor = Graphics.COLOR_BLUE;
			fSize = $.fontXTiny;
		}
  		
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
  		
        dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, fSize, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
}