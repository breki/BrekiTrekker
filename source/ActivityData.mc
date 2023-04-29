import Toybox.Lang;
import Toybox.Time;

class ActivityData {
    function startActivity() {
        activityRunning = true;
        startTime = Time.now();
    }

    function activityDuration() as Duration or Null {
        if (!activityRunning) {
            return null;
        }
        else {
            return Time.now().subtract(startTime);
        }
    }

    static function initial() as ActivityData {
        return new ActivityData();
    }

    var activityRunning = false;
    var startTime as Moment or Null;
}