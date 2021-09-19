using Toybox.WatchUi as Ui;

var fontXXTiny, fontXTiny, fontTiny, fontSmall, fontNormal, fontBig, fontLarge, fontXLarge, fontIcons; 

// TTF files convered at https://snowb.org/
function loadResources() {
    // $.logMessage("Resources::loadResources ENTER");

	// $.fontXXTiny = Ui.loadResource(Rez.Fonts.Roboto6Font);
	$.fontXTiny = Ui.loadResource(Rez.Fonts.Roboto8Font);
	$.fontTiny = Ui.loadResource(Rez.Fonts.Roboto16Font);
	$.fontSmall = Ui.loadResource(Rez.Fonts.Roboto18Font);
	// $.fontNormal = Ui.loadResource(Rez.Fonts.Roboto24Font);
	// $.fontBig = Ui.loadResource(Rez.Fonts.Roboto48Font);
	// $.fontLarge = Ui.loadResource(Rez.Fonts.Roboto60Font);
	$.fontXLarge = Ui.loadResource(Rez.Fonts.Roboto72Font);

    // $.logMessage("Resources::loadResources EXIT");
}