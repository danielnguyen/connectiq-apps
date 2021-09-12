using Toybox.Activity;
using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Background;
using Toybox.Lang;
using Toybox.Position;
using Toybox.Time;
using Toybox.WatchUi;

class UVTrackerApp extends Application.AppBase {

    var REFRESH_INTERVAL = 0;

    function initialize() {
        AppBase.initialize();
        REFRESH_INTERVAL = $.DEV_MODE ? 5 : 60;
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        $.logMessage("App::onStart");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        $.logMessage("App::onStop");
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        $.logMessage("App::getInitialView ENTER");

        // Get latest position and cache it
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));

        Background.deleteTemporalEvent();

        Storage.setValue("DataRefreshInterval", REFRESH_INTERVAL);
        var duration = new Time.Duration(REFRESH_INTERVAL * 60);

        if(Background.getLastTemporalEventTime() == null) { //just for first run
            Background.registerForTemporalEvent(Time.now());
            $.logMessage("getInitialView: No last TemporalEvent, registered NOW");      
        }
        else {
             Background.registerForTemporalEvent(Background.getLastTemporalEventTime().add(duration));
             $.logMessage("getInitialView: TemporalEvent registered as last + refreshInterval");
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
        
    	Storage.setValue($.STORAGE_UV_DATA, data);

        //Following update and refresh, set duration to trigger every hour
        var duration = new Time.Duration(REFRESH_INTERVAL * 60);
        try {
            Background.deleteTemporalEvent();
            Background.registerForTemporalEvent(Background.getLastTemporalEventTime().add(duration));
            $.logMessage("App::onBackgroundData: TemporalEvent registered as last + refreshInterval");     
        }
        catch(exception) {
           $.logMessage(exception);
        }
        
        WatchUi.requestUpdate();
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