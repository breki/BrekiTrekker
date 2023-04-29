import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;

class ActivityDisplay extends WatchUi.Drawable {
    function initialize(params as Object) {
        Drawable.initialize(params);

        var activityRunning = false;
        updateData(activityRunning, new Duration(0));
    }

    function updateData(
        activityRunning as Boolean, activityDuration as Duration) {
        _activityRunning = activityRunning;
        _activityDuration = activityDuration;
    }

    function draw(dc as Dc) as Void {
        var timerText;

        if (_activityRunning) {
            var activityDurationInSeconds = _activityDuration.value();
            var minutes = Math.floor(activityDurationInSeconds / 60);
            var seconds = activityDurationInSeconds % 60;

            // display time in MM:SS format
            timerText = Lang.format(
                "$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);
        }
        else {
            timerText = "00:00";
        }

        var screenSize = 240;

        var x = screenSize / 2;
        var y = screenSize / 2;
        var font = Graphics.FONT_NUMBER_THAI_HOT;
        var justification = 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, timerText, justification);
    }

    private var _activityRunning;
    private var _activityDuration;
}