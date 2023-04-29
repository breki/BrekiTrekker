import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Timer;

class BrekiTrekkerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(
            new Rez.Menus.MainMenu(), 
            new BrekiTrekkerMenuDelegate(), 
            WatchUi.SLIDE_UP);
        return true;
    }

    // on the SELECT button press
    function onSelect() as Boolean {
        if (!activityData.activityRunning) {
            _startTimer();
        } 

        return true;
    }

    function _startTimer() {
        activityData.startActivity();
        activityTimer = new Timer.Timer();
        var repeat = true; // the Timer will repeat until stop() is called
        activityTimer.start(method(:_updateActivityView), 1000, repeat);
        
        _updateActivityView();
    }

    function _updateActivityView() as Void {
        activityView.updateView(activityData);
    }

    private var activityData = new ActivityData();
    private var activityTimer;
    private var activityView = getApp().getActivityView();
}