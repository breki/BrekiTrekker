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
        System.println("onSelect");

        var stateBefore = activityData.state;

        activityData.onSelectButton();

        var stateAfter = activityData.state;

        if (stateBefore == AppState.INITIAL && stateAfter == AppState.RUNNING) {
            activityTimer = new Timer.Timer();
            var repeat = true; // the Timer will repeat until stop() is called
            activityTimer.start(method(:_updateActivityView), 1000, repeat);
        }
        
        _updateActivityView();

        return true;
    }

    function onBack() as Boolean {
        System.println("onBack");
        activityData.onBackButton();

        _updateActivityView();

        return true;
    }

    function onNextPage() as Boolean {
        System.println("onNextPage");

        var refreshDisplay = activityData.onNextPageButton();
        if (refreshDisplay) {
            _updateActivityView();
        }

        return true;
    }

    function onPreviousPage() as Boolean {
        System.println("onPreviousPage");
        var refreshDisplay = activityData.onPreviousPageButton();
        if (refreshDisplay) {
            _updateActivityView();
        }

        return true;
    }

    function _updateActivityView() as Void {
        activityView.updateView(activityData);
    }

    private var activityData = new ActivityData();
    private var activityTimer;
    private var activityView = getApp().getActivityView();
}