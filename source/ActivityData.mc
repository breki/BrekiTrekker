import Toybox.Lang;
import Toybox.Time;

class AppState { 
    enum {
        INITIAL,
        RUNNING,
        BACK_BUTTON_DISPLAY
    }
}

class ActivityData {
    function onSelectButton() {
        switch (state) {
            case AppState.INITIAL: {
                startActivity();
                break;
            }
        }
    }

    function onBackButton() {
        switch (state) {
            case AppState.RUNNING: {
                state = AppState.BACK_BUTTON_DISPLAY;
                break;
            }
            case AppState.BACK_BUTTON_DISPLAY: {
                state = AppState.RUNNING;
                break;
            }
        }
    }

    function startActivity() {
        state = AppState.RUNNING;
        startTime = Time.now();
    }

    function activityDuration() as Duration or Null {
        if (startTime != null) {
            return Time.now().subtract(startTime);
        }
        else {
            return null;
        }
    }

    static function initial() as ActivityData {
        return new ActivityData();
    }

    var state = AppState.INITIAL;
    var startTime as Moment or Null;
}