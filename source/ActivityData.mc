import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.Attention;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Timer;

class ActivityData {
    function activityType() as ActivityType {
        return activityTypes[selectedActivityTypeIndex];
    }

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
            case AppState.MENU_DISPLAY:
                switch (selectedMenuItem) {
                    case MenuItem.RECORD_STOP: {
                        state = AppState.SAVING;
                        activitySession.stop();
                        activitySession.save();
                        activitySession = null;
                        // todo 0: create a reminder timer
                        savedReminderTimer = new Timer.Timer();
                        var repeat = true; // the Timer will repeat until stop() is called
                        savedReminderTimer.start(
                            method(:_doReminderSignal), 10000, repeat);
                        break;
                    }
                    case MenuItem.DISCARD: {
                        state = AppState.CONFIRM_DISCARD;
                        break;
                    }
                }

                break;
            case AppState.CONFIRM_DISCARD: {
                state = AppState.DISCARDING;
                activitySession.discard();
                break;
            }
            case AppState.SAVING:
            case AppState.DISCARDING: {
                System.exit();                
            }
        }
    }

    function onBackButton() {
        switch (state) {
            case AppState.INITIAL: {
                System.exit();                
            }
            case AppState.RUNNING: {
                state = AppState.BACK_BUTTON_DISPLAY;
                break;
            }
            case AppState.MENU_DISPLAY:
            case AppState.BACK_BUTTON_DISPLAY: {
                state = AppState.RUNNING;
                break;
            }
            case AppState.CONFIRM_DISCARD: {
                state = AppState.RUNNING;
                break;
            }
            case AppState.SAVING:
            case AppState.DISCARDING: {
                System.exit();                
            }
        }
    }

    function onNextPageButton() as Boolean {
        switch (state) {
            case AppState.INITIAL: {
                selectedActivityTypeIndex = 
                    (selectedActivityTypeIndex + 1) % activityTypes.size();
                return true;
            }
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
            case AppState.SAVING:
            case AppState.DISCARDING: {
                System.exit();                
            }
            default: {
                return false;
            }
        }
    }

    function onPreviousPageButton() as Boolean {
        switch (state) {
            case AppState.INITIAL: {
                selectedActivityTypeIndex = selectedActivityTypeIndex - 1;
                if (selectedActivityTypeIndex < 0) {
                    selectedActivityTypeIndex = activityTypes.size() - 1;
                }
                return true;
            }
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
            case AppState.SAVING:
            case AppState.DISCARDING: {
                System.exit();                
            }
            default: {
                return false;
            }
        }
    }

    function startActivity() {
        state = AppState.RUNNING;
        startTime = Time.now(); //.add(new Duration(-6444));

        var activityType = self.activityType();
        activitySession = ActivityRecording.createSession({
            :name => activityType.nameLong,
            :sport => activityType.sport,
            // :sensorLogger => 
        });
        activitySession.start();
    }

    function activityDuration() as Duration or Null {
        if (startTime != null) {
            return Time.now().subtract(startTime);
        }
        else {
            return null;
        }
    }

    function setHeartRate(value as Number or Null) {
        heartRate.setValue(value);
    }

    function setBarometricAltitude(value as Number or Null) {
        barometricAltitude.setValue(value);
    }

    function setGpsAltitude(value as Number or Null) {
        gpsAltitude.setValue(value);
    }

    function barometricAscent() as Number or Null {
        return barometricAltitude.maxMinCurrentDiff;
    }

    function gpsAscent() as Number or Null {
        return gpsAltitude.maxMinCurrentDiff;
    }

    function setTemperature(value as Number or Null) {
        temperature.setValue(value);
    }

    static function initial() as ActivityData {
        return new ActivityData();
    }

    // Vibrate and sound a reminder signal that the activity has been saved
    // and the user can exit the app.
    function _doReminderSignal() as Void {
        var vibeProfiles =
        [
            new Attention.VibeProfile(50, 2000), // On for two seconds
        ];

        Attention.vibrate(vibeProfiles);

        var toneProfile =
        [
            new Attention.ToneProfile( 2500, 250),
            new Attention.ToneProfile( 5000, 250),
            new Attention.ToneProfile(10000, 250),
            new Attention.ToneProfile( 5000, 250),
            new Attention.ToneProfile( 2500, 250),
        ];
        Attention.playTone({:toneProfile=>toneProfile});
    }

    var state = AppState.INITIAL;
    var activityTypes as Array<ActivityType> = [
            new ActivityType("WALK", "Walking", Activity.SPORT_WALKING),
            new ActivityType("HIKE", "Hiking", Activity.SPORT_HIKING),
            new ActivityType("RUN", "Running", Activity.SPORT_RUNNING)
        ];
    var selectedActivityTypeIndex = 0;
    var startTime as Moment or Null;
    var elapsedDistance as Number or Null;
    var heartRate = new ActivityParameter();
    var barometricAltitude = new ActivityParameter();
    var gpsAltitude = new ActivityParameter();
    var totalAscent as Number or Null;
    var temperature = new ActivityParameter();
    var batteryLevel as Number or Null;
    var activitySession as Session or Null;
    var selectedMenuItem = MenuItem.NONE;

    private var savedReminderTimer;
}
