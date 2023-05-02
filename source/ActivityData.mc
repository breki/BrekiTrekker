import Toybox.Lang;
import Toybox.Time;

class AppState { 
    enum {
        INITIAL,
        RUNNING,
        MENU_DISPLAY,
        BACK_BUTTON_DISPLAY
    }
}

class MenuItem {
    enum {
        NONE,
        RECORD_STOP,
        DISCARD
    }
}

class ActivityData {
    function onSelectButton() {
        switch (state) {
            case AppState.INITIAL: {
                startActivity();
                break;
            }
            case AppState.RUNNING:
            case AppState.BACK_BUTTON_DISPLAY: {
                state = AppState.MENU_DISPLAY;
                selectedMenuItem = MenuItem.NONE;
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
            case AppState.MENU_DISPLAY:
            case AppState.BACK_BUTTON_DISPLAY: {
                state = AppState.RUNNING;
                break;
            }
        }
    }

    function onNextPageButton() as Boolean {
        switch (state) {
            case AppState.MENU_DISPLAY: {
                switch (selectedMenuItem) {
                    case MenuItem.RECORD_STOP: {
                        selectedMenuItem = MenuItem.DISCARD;
                        return true;
                    }
                    case MenuItem.DISCARD:
                    case MenuItem.NONE: {
                        selectedMenuItem = MenuItem.RECORD_STOP;
                        return true;
                    }
                }
                return true;
            }
            default: {
                return false;
            }
        }
    }

    function onPreviousPageButton() as Boolean {
        switch (state) {
            case AppState.MENU_DISPLAY: {
                switch (selectedMenuItem) {
                    case MenuItem.RECORD_STOP: {
                        selectedMenuItem = MenuItem.DISCARD;
                        return true;
                    }
                    case MenuItem.DISCARD:
                    case MenuItem.NONE: {
                        selectedMenuItem = MenuItem.RECORD_STOP;
                        return true;
                    }
                }
                return true;
            }
            default: {
                return false;
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
    var selectedMenuItem = MenuItem.NONE;
}