using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;
using Toybox.Weather;

class Weather extends Ui.Drawable {

	var ROW_HEIGHT = 10;

	function initialize() {
		Drawable.initialize({ :identifier => "Weather" });
	}
	
	function draw(dc) {

		var currentWeather = Weather.getCurrentConditions();

		var uv = Storage.getValue("uv");
		var precipitation = currentWeather.precipitationChance;
		var temperature = currentWeather.temperature.format("%02d");

		var x = ( $.SCREEN_X / 2), y = ROW_HEIGHT;
		var label = "WEATHER";
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);
		
		drawUV(dc, uv);
		drawPrecipitation(dc, precipitation);
		drawTemperature(dc, temperature);
  	}
  	
  	function drawUV(dc, uv) {
  		var x = ( $.SCREEN_X / 2 ) - 35, y = ROW_HEIGHT;

  		var label = "UV";
		var fColor = Graphics.COLOR_WHITE;
		var value = "-";

		if (uv instanceof Float || uv instanceof Number) {

			if (uv >= 3 && uv < 6) {
				fColor = Graphics.COLOR_YELLOW;
				$.buzz();
			} else if (uv >= 6 && uv < 8) {
				fColor = Graphics.COLOR_ORANGE;
				$.buzz();
			} else if (uv >= 8 && uv < 11) {
				fColor = Graphics.COLOR_RED;
				$.buzz();
			} else if (uv >= 11) {
				fColor = Graphics.COLOR_PURPLE;
				$.buzz();
			}

			value = uv.toNumber();
		}

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 18, y + 17, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawPrecipitation(dc, value) {
  		var x = ( $.SCREEN_X / 2 ), y = ROW_HEIGHT;
  		
  		var label = "%";
		  
		var fColor = Graphics.COLOR_WHITE;

		if (value >= 70) {
			fColor = Graphics.COLOR_BLUE;
		}

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 15, y + 18, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
  	
  	function drawTemperature(dc, value) {
  		var x = $.SCREEN_X - 90, y = ROW_HEIGHT;
  		
  		var label = "C";

		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 15, y + 18, $.fontXTiny, label, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 10, $.fontTiny, value, Graphics.TEXT_JUSTIFY_CENTER);
  	}
}