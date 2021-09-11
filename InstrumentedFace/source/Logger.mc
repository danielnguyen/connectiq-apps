using Toybox.System;

(:background, :debug)
function logMessage(msg){
    if ($.DEBUG_MODE) {
    var t = System.getClockTime();
	System.println(
        t.hour.format("%02d") 
        + ":" + t.min.format("%02d") 
        + ":" + t.sec.format("%02d") 
        + ": " + msg);
    }
}

(:background, :release)
function logMessage(msg){
	//do nothing :)
	// var t = System.getClockTime();
	// System.println(
    //     t.hour.format("%02d") 
    //     + ":" + t.min.format("%02d") 
    //     + ":" + t.sec.format("%02d") 
    //     + ": " + msg);
}