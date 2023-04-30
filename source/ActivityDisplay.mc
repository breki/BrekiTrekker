import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;

class ActivityDisplay extends WatchUi.Drawable {
    function initialize(params as Object) {
        Drawable.initialize(params);
    }

    function updateData(activityData as ActivityData) {
        _activityData = activityData;
    }

    function draw(dc as Dc) as Void {
        switch (_activityData.state) {
            case AppState.INITIAL: {
                _drawStartupScreen(dc);
                break;
            }
            case AppState.STARTED:
            case AppState.BACK_BUTTON_DISPLAY: {
                _drawActivityScreen(dc);
                break;
            }
        }
    }

    function _drawStartupScreen(dc as Dc) as Void {
        var timerText = "START";

        var font = Graphics.FONT_MEDIUM;
        var justification = 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

        var x = screenSize / 2;
        var y = screenSize / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, timerText, justification);
    }

    function _drawActivityScreen(dc as Dc) as Void {
        var activityDurationInSeconds = _activityData.activityDuration().value();
        var minutes = Math.floor(activityDurationInSeconds / 60);
        var seconds = activityDurationInSeconds % 60;

        var x = screenSize / 2;
        var y = screenSize / 2;

        // display time in MM:SS format
        var timerText = Lang.format(
            "$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);

        var justification = 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_NUMBER_THAI_HOT, timerText, justification);

        if (_activityData.state == AppState.BACK_BUTTON_DISPLAY) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
            dc.drawText(
                x, y, Graphics.FONT_MEDIUM, 
                "press START\nto stop/record", justification);
        }
    }

    // todo: can we find the display size constant?
    private var screenSize = 240;
    private var _activityData;
}