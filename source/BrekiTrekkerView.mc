import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;

class BrekiTrekkerView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        activityDisplay = findDrawableById("activity_display");

        var activityRunning = false;
        updateView(activityRunning, new Duration(0));
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

    function updateView(
        activityRunning as Boolean, activityDuration as Duration) as Void {

        activityDisplay.updateData(activityRunning, activityDuration);

        // Request a call to the onUpdate() method for the current View
        WatchUi.requestUpdate();
    }

    private var activityDisplay;
}
