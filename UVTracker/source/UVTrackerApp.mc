using Toybox.Activity;
using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Background;
using Toybox.Lang;
using Toybox.Position;
using Toybox.Time;
using Toybox.WatchUi as Ui;

class UVTrackerApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        $.logMessage("App::onStart");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        $.logMessage("App::onStop");
        // Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        // Clean up and delete registered temporal event
        Background.deleteTemporalEvent();
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        $.logMessage("App::getInitialView ENTER");

        // Get latest position and cache it
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));

        if(Toybox.System has :ServiceDelegate) {
            $.logMessage("App::Registering Temporal Event (immediate).");\
            Background.registerForTemporalEvent(Time.now());
    	} else {
    		$.logMessage("****background not available on this device****");
    	}
        $.logMessage("App::getInitialView EXIT");
        return [ new UVTrackerView() ];
    }

    function getServiceDelegate(){
        return [new OpenUVServiceDelegate()];
    }
    
    // Called when ServiceDelegate returns data
    function onBackgroundData(data) {
        $.logMessage("App::onBackgroundData ENTER");
        
        $.logMessage("App::Registering Temporal Event (1 hour).");\
        Background.registerForTemporalEvent(new Time.Duration(60 * 60));
    	Storage.setValue($.STORAGE_UV_DATA, data);
        
        Ui.requestUpdate();
        $.logMessage("App::onBackgroundData EXIT");
    }

    function onPosition(info) {
        $.logMessage("App::onPosition ENTER");
        Storage.setValue($.STORAGE_LOCATION, info.position.toDegrees());
        $.logMessage("App::onPosition EXIT");
    }

}

function getApp() as UVTrackerApp {
    return Application.getApp() as UVTrackerApp;
}