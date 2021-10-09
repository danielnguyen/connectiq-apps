var DEBUG_MODE = false;
var DEV_MODE = false;

// Char ids from resources/fonts/icons.fnt
var ICON_ALARM = 82.toChar(); 	    // 'R' 
var ICON_BLUETOOTH = 86.toChar();   // 'V'
var ICON_CALORIES = 88.toChar(); 	// 'X'
var ICON_HEART = 109.toChar(); 	    // 'm' 
var ICON_PEOPLE = 121.toChar(); 	// 'y'
var ICON_PHONE = 193.toChar();  	// 'Á'
var ICON_STEPS = 196.toChar(); 	    // 'Ä'
var ICON_WIFI = 207.toChar();		// 'Ï'

enum CUSTOM_COLORS {
    COLOR_BEIGE = 0xffaaaa,
    COLOR_GREEN = 0x00ffaa,
    COLOR_LT_BLUE = 0xaaffff
}

enum UVIndex {
    UV_INDEX_UNKNOWN,
    UV_INDEX_LOW,
    UV_INDEX_MEDIUM,
    UV_INDEX_HIGH,
    UV_INDEX_VERY_HIGH,
    UV_INDEX_EXTREME
}