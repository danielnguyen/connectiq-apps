using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.WatchUi as Ui;

class Location extends Ui.Drawable {

	var LOCATIONS = [
		{ :code => "canada", :name => Application.loadResource($.Rez.Strings.location_label_canada) },
		{ :code => "AB", :name => Application.loadResource($.Rez.Strings.location_label_ab) },
		{ :code => "BC", :name => Application.loadResource($.Rez.Strings.location_label_bc) },
		{ :code => "MB", :name => Application.loadResource($.Rez.Strings.location_label_mb) },
		{ :code => "NB", :name => Application.loadResource($.Rez.Strings.location_label_nb) },
		{ :code => "NL", :name => Application.loadResource($.Rez.Strings.location_label_nl) },
		{ :code => "NT", :name => Application.loadResource($.Rez.Strings.location_label_nt) },
		{ :code => "NS", :name => Application.loadResource($.Rez.Strings.location_label_ns) },
		{ :code => "NU", :name => Application.loadResource($.Rez.Strings.location_label_nu) },
		{ :code => "ON", :name => Application.loadResource($.Rez.Strings.location_label_on) },
		{ :code => "PE", :name => Application.loadResource($.Rez.Strings.location_label_pe) },
		{ :code => "QC", :name => Application.loadResource($.Rez.Strings.location_label_qc) },
		{ :code => "SK", :name => Application.loadResource($.Rez.Strings.location_label_sk) },
		{ :code => "YT", :name => Application.loadResource($.Rez.Strings.location_label_yt) },
		{ :code => "RP", :name => Application.loadResource($.Rez.Strings.location_label_rp) },
	];

	function initialize() {
		Drawable.initialize({ :identifier => "Location" });
	}
	
	function draw(dc) {

		var app = Application.getApp();

		// var bgData = Storage.getValue($.STORAGE_UV_DATA);

		var value = "-";

		var locIndex = app.getProperty("selected_location");
		value = "New cases in " + getLocationNameByIndex(locIndex);

		var x = dc.getWidth() / 2;
		var y = dc.getHeight() / 5;

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(x, y, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_CENTER);
		
	}

	function getLocationNameByIndex(value) {
		if (value > LOCATIONS.size() || LOCATIONS[value][:name] == null) {
			return null;
		}
		return LOCATIONS[value][:name];
	}
}