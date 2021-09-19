using Toybox.Graphics;
using Toybox.WatchUi;

using Toybox.Graphics as Gfx;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Time.Gregorian;

class UVTrackerView extends WatchUi.View {

    var _message as String = "";

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout( Rez.Layouts.MainLayout( dc ) );
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        $.loadResources();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
