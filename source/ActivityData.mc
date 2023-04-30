import Toybox.Lang;
import Toybox.Time;

class AppState { 
    enum {
        INITIAL,
        STARTED,
        BACK_BUTTON_DISPLAY
    }
}

class ActivityData {
    function startActivity() {
        state = AppState.STARTED;
        startTime = Time.now();
    }

    function onBackButton() {
        switch (state) {
            case AppState.STARTED: {
                state = AppState.BACK_BUTTON_DISPLAY;
                break;
            }
            case AppState.BACK_BUTTON_DISPLAY: {
                state = AppState.STARTED;
                break;
            }
        }
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