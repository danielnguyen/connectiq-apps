using Toybox.WatchUi as Ui;
using Toybox.Graphics;

var fontXXTiny, fontXTiny, fontTiny, fontSmall, fontNormal, fontBig, fontLarge, fontXLarge, fontIcons; 

// TTF files convered at https://snowb.org/
function loadResources() {
    // $.logMessage("Resources::loadResources ENTER");

	// $.fontXXTiny = // loadResource(Rez.Fonts.Roboto6Font);
	$.fontXTiny = Graphics.FONT_XTINY;// loadResource(Rez.Fonts.Roboto8Font);
	$.fontTiny = Graphics.FONT_TINY;// loadResource(Rez.Fonts.Roboto16Font);
	$.fontSmall = Graphics.FONT_SMALL;// loadResource(Rez.Fonts.Roboto18Font);
	// $.fontNormal = // loadResource(Rez.Fonts.Roboto24Font);
	// $.fontBig = // loadResource(Rez.Fonts.Roboto48Font);
	// $.fontLarge = // loadResource(Rez.Fonts.Roboto60Font);
	$.fontXLarge = Graphics.FONT_LARGE;// loadResource(Rez.Fonts.Roboto72Font);
	// $.fontIcons = loadResource(Rez.Fonts.IconsFont);

    // $.logMessage("Resources::loadResources EXIT");
}