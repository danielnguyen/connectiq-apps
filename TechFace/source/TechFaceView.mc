using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Sensor;
using Toybox.System;
using Toybox.WatchUi;

class TechFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        $.loadResources();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
    	if(dc has :setAntiAlias) {
			dc.setAntiAlias(true);
		}
		
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
}
