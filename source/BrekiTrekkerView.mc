import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class BrekiTrekkerView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        timerElement = findDrawableById("timer");

        updateTimer(5);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
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

    function updateTimer(time as Number) as Void {
        var minutes = Math.floor(time / 60);
        var seconds = time % 60;

        // display time in MM:SS format
        var timeStr = _zeroPadded(minutes) + ":" + _zeroPadded(seconds);

        timerElement.setText(timeStr);

        // Request a call to the onUpdate() method for the current View
        WatchUi.requestUpdate();
    }

    function _zeroPadded(num as Number) as String {
        if (num < 10) {
            return "0" + num.toString();
        } else {
            return num.toString();
        }
    }

    private var timerElement;
}
