import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// The handler for application lifecycle events.
class BrekiTrekkerApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting.
    // This gives your application the option to save state before termination.
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() {
        activityView = new BrekiTrekkerView();
        return [ activityView, new BrekiTrekkerDelegate() ];
    }

    function getActivityView() as BrekiTrekkerView {
        return activityView;
    }

    private var activityView;
}

function getApp() as BrekiTrekkerApp {
    return Application.getApp() as BrekiTrekkerApp;
}