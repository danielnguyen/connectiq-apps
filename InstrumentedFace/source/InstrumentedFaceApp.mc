using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Background;
using Toybox.Lang;
// using Toybox.Position;
import Toybox.Time;
using Toybox.WatchUi;

class InstrumentedFaceApp extends Application.AppBase {

    var REFRESH_INTERVAL = 0;

    function initialize() {
        AppBase.initialize();
        REFRESH_INTERVAL = $.DEV_MODE ? 5 : 60;
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {

        // WatchFace not allowed to call enableLocationEvents: https://developer.garmin.com/connect-iq/core-topics/manifest-and-permissions/#fn:2
        // Get latest position and cache it
        // Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        
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

            // Update the view if data available
            updateData(null);
        }
        
        return [ new InstrumentedFaceView() ] as Array<Views or InputDelegates>;
    }

    function getServiceDelegate(){
        return [new BackgroundService()];
    }
    
    // Called when ServiceDelegate returns data
    function onBackgroundData(data) {
        $.logMessage("App::onBackgroundData ENTER");

        if (data != null) {
            updateData(data);
        }
        
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
        $.logMessage("App::onBackgroundData EXIT");
    }
    
    function updateData(data) {
        $.logMessage("App::updateData ENTER");

    	if(data != null) {
    		var today = Time.today().value();
    	
	    	Storage.setValue("DataUpdated", data["updated"]);
            if (data["position"] instanceof String) {
                $.logMessage("Location updated");
                Storage.setValue("LocationUpdated", data["updated"]);
	            Storage.setValue("position", data["position"]);
            }
            if (data["uv"] instanceof Number || data["uv"] instanceof Float ) {
                $.logMessage("UV updated");
	            Storage.setValue("uv", data["uv"].toNumber());
            }
            if (data["covid19data_on"] != null) {
                $.logMessage("Ontario single day Covid data updated");
	            Storage.setValue("covid19data_on", data["covid19data_on"]);
            }
            if (data["covid19data_on_14days"] != null) {
                $.logMessage("Ontario 14 days Covid data updated");
	            Storage.setValue("covid19data_on_14days", data["covid19data_on_14days"]);
            }
            if (data["covid19data_tor"] != null) {
                $.logMessage("Toronto Covid data updated");
	            Storage.setValue("covid19data_tor", data["covid19data_tor"]);
            }
            if (data["covid19data_york"] != null) {
                $.logMessage("York Region Covid data updated");
	            Storage.setValue("covid19data_york", data["covid19data_york"]);
            }
    	}
        WatchUi.requestUpdate();
        $.logMessage("App::updateData EXIT");
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        WatchUi.requestUpdate();
    }

    function onPosition(info) {
        $.logMessage("App::onPosition ENTER");
        $.logMessage("Location updated");
        Storage.setValue("LocationUpdated", data["updated"]);
        Storage.setValue("position", info.position);
        $.logMessage("App::onPosition EXIT");
    }

}

function getApp() as InstrumentedFaceApp {
    return Application.getApp() as InstrumentedFaceApp;
}