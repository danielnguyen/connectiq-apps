using Toybox.WatchUi as Ui;

var FONT_XXTINY, FONT_XTINY, FONT_TINY, FONT_SMALL, FONT_NORMAL, FONT_BIG, FONT_LARGE, FONT_XLARGE, FONT_Icons; 

// TTF files convered at https://snowb.org/
function loadResources() {
    // $.logMessage("Resources::loadResources ENTER");

	$.FONT_XXTINY = Ui.loadResource(Rez.Fonts.Roboto8Font);
	$.FONT_XTINY = Ui.loadResource(Rez.Fonts.Roboto10Font);
	$.FONT_TINY = Ui.loadResource(Rez.Fonts.Roboto16Font);
	$.FONT_SMALL = Ui.loadResource(Rez.Fonts.Roboto18Font);
	$.FONT_NORMAL = Ui.loadResource(Rez.Fonts.Roboto24Font);
	$.FONT_BIG = Ui.loadResource(Rez.Fonts.Roboto48Font);
	$.FONT_LARGE = Ui.loadResource(Rez.Fonts.Roboto60Font);
	$.FONT_XLARGE = Ui.loadResource(Rez.Fonts.Roboto72Font);
	
	// $.FONT_XXTINY = Ui.loadResource(Rez.Fonts.Squared6Font);
	// $.FONT_XTINY = Ui.loadResource(Rez.Fonts.Squared8Font);
	// $.FONT_TINY = Ui.loadResource(Rez.Fonts.Squared16Font);
	// $.FONT_SMALL = Ui.loadResource(Rez.Fonts.Squared18Font);
	// $.FONT_NORMAL = Ui.loadResource(Rez.Fonts.Squared24Font);
	// $.FONT_BIG = Ui.loadResource(Rez.Fonts.Squared48Font);
	// $.FONT_LARGE = Ui.loadResource(Rez.Fonts.Squared60Font);
	// $.FONT_XLARGE = Ui.loadResource(Rez.Fonts.Squared72Font);

    // $.logMessage("Resources::loadResources EXIT");
}