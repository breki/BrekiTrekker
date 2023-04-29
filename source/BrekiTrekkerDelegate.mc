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
        if (!inProgress) {
            _startTimer();
        } 

        return true;
    }

    function _startTimer() {
        inProgress = true;
        startTime = Time.now();
        updateTimer = new Timer.Timer();
        updateTimer.start(method(:_updateActivityView), 1000, true);
        
        _updateActivityView();
    }

    function _updateActivityView() as Void {
        var elapsed = Time.now().subtract(startTime);

        activityView.updateTimer(elapsed.value());
    }

    private var inProgress = false;
    private var startTime;
    private var updateTimer;
    private var activityView = getApp().getActivityView();
}