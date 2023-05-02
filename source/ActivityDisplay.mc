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
            case AppState.RUNNING:
            case AppState.MENU_DISPLAY:
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

        var centerX = screenSize / 2;
        var centerY = screenSize / 2;

        // display time in MM:SS format
        var timerText = Lang.format(
            "$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);

        var hvCenter = 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY, 
        Graphics.FONT_NUMBER_THAI_HOT, timerText, hvCenter);

        switch (_activityData.state) {
            case AppState.MENU_DISPLAY: { 
                _drawMenu(dc, centerX);
                break;
            }

            case AppState.BACK_BUTTON_DISPLAY: {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.drawText(
                    centerX, centerY + 30, Graphics.FONT_TINY, 
                    "press START\nto record/stop", Graphics.TEXT_JUSTIFY_CENTER);

                break;
            }
        }
    }

    function _drawMenu(dc as Dc, centerX as Number) as Void {
        if (_activityData.selectedMenuItem == MenuItem.RECORD_STOP) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_ORANGE);
        }
        else {
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        }

        dc.drawText(
            centerX, 30, Graphics.FONT_TINY, 
            "      RECORD & STOP      ", Graphics.TEXT_JUSTIFY_CENTER);

        if (_activityData.selectedMenuItem == MenuItem.DISCARD) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_ORANGE);
        }
        else {
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        }

        dc.drawText(
            centerX, 60, Graphics.FONT_TINY, 
            "               DISCARD               ", Graphics.TEXT_JUSTIFY_CENTER);
    }

    // todo: can we find the display size constant?
    private var screenSize = 240;
    private var _activityData;
}