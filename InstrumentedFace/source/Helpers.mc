using Toybox.Application.Storage;
using Toybox.Time;
// using Toybox.Attention;

enum VibrationStrength {
    VIBRATION_WEAK,
    VIBRATION_MODERATE,
    VIBRATION_STRONG
}
// Tone notification
function ring(tone) {
    // Can't use Attention in WatchFace
    
    // if (tone instanceof ToneProfile) {
    //     Attention.playTone(tone);
    // }
}

// Vibration notification
function buzz(){
    // Can't use Attention in WatchFace

    // var vibeData;
    // if (Attention has :vibrate) {
    //     vibeData =
    //     [
    //         new Attention.VibeProfile(10, 500)
    //     ];
    //     Attention.vibrate(vibeData);
    // }
}

// Returns true if the UI component should redraw.
function shouldRedraw() {
    var ret;
    var lastRedrawTime = Storage.getValue("lastRedrawTime");
    var oneHour = new Time.Duration(10);

    if(lastRedrawTime != null && Time.now().subtract(new Time.Moment(lastRedrawTime)).value() < oneHour.value()) {
        ret = false;
    } else {
        Storage.setValue("lastRedrawTime", Time.now().value());
        ret = true;
    }
    return ret;
}