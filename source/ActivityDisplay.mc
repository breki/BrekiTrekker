import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;

class ActivityDisplay extends WatchUi.Drawable {
    function initialize(params as Object) {
        Drawable.initialize(params);

        var device = System.getDeviceSettings();
 
        screenWidth = device.screenWidth;
        screenHeight = device.screenHeight;
        centerX = screenWidth / 2;
        centerY = screenHeight / 2;
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
            case AppState.SAVING:
                _drawSavingScreen(dc);
                break;
            case AppState.CONFIRM_DISCARD:
                _drawConfirmDiscardScreen(dc);
                break;
            case AppState.DISCARDING:
                _drawDiscardingScreen(dc);
                break;
        }
    }

    function _drawStartupScreen(dc as Dc) as Void {
        var font = Graphics.FONT_MEDIUM;
        var justification = 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

        var activityTypes = _activityData.activityTypes as Array<ActivityType>;
        var activitiesCount = activityTypes.size();
        var startingY = centerY - (activitiesCount - 1) * 30 / 2;

        for (var i = 0; i < activitiesCount; i++) {

            var activityType = activityTypes[i];
            var text = "            " + activityType.nameShort + " ->            ";

            if (i == _activityData.selectedActivityTypeIndex) {
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_ORANGE);
            }
            else {
                dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
            }
            // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, startingY + i * 30, font, text, justification);
        }

        if (_activityData.barometricAltitude.currentValue != null) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);

            var altText = Lang.format("$1$m", 
                [_activityData.barometricAltitude.currentValue.format("%d")]);

            dc.drawText(centerX, startingY + (activitiesCount + 1) * 30, 
                Graphics.FONT_TINY, altText, justification); 
        }
    }

    function _drawActivityScreen(dc as Dc) as Void {
        _drawTime(dc);
        _drawTimer(dc);
        _drawHeartRate(dc);
        _drawAltitude(dc);
        _drawTemperature(dc);
        _drawBatteryLevel(dc);

        switch (_activityData.state) {
            case AppState.MENU_DISPLAY: { 
                _drawMenu(dc);
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

    function _drawTime(dc as Dc) as Void {
        var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var timeText = Lang.format(
            "$1$:$2$", [now.hour.format("%02d"), now.min.format("%02d")]);

        var hvCenter = 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, 10, Graphics.FONT_TINY, timeText, hvCenter);
    }

    function _drawTimer(dc as Dc) as Void {
        var activityDurationInSeconds = _activityData.activityDuration().value();
        var hours = Math.floor(activityDurationInSeconds / 3600);
        var minutes = Math.floor(activityDurationInSeconds / 60 % 60);
        var seconds = activityDurationInSeconds % 60;

        var timerText;
        
        if (hours == 0) {
            timerText = Lang.format(
                "$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);
        }
        else {
            timerText = Lang.format(
                "$1$:$2$:$3$", 
                [hours, minutes.format("%02d"), seconds.format("%02d")]);
        }

        var hvCenter = 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY + 100, 
            Graphics.FONT_XTINY, timerText, hvCenter);
    }

    function _drawHeartRate(dc as Dc) as Void {
        var heartRate = _activityData.heartRate.currentValue;

        var color;
        if (heartRate == null) { color = Graphics.COLOR_GREEN; }
        else if (heartRate >= 170) { color = Graphics.COLOR_DK_RED; }
        else if (heartRate >= 150) { color = Graphics.COLOR_RED; }
        else if (heartRate >= 130)  { color = Graphics.COLOR_ORANGE; }
        else if (heartRate >= 110)  { color = Graphics.COLOR_YELLOW; }
        else { color = Graphics.COLOR_GREEN; }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var xPos = 50;
        var heartRateText;
        
        if (heartRate != null) { heartRateText = Lang.format("$1$", [heartRate]); }
        else { heartRateText = "---"; }

        dc.drawText(centerX + xPos, centerY, 
            Graphics.FONT_NUMBER_THAI_HOT, heartRateText, 
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.drawText(centerX + xPos + 5, centerY + 20, 
            Graphics.FONT_XTINY, "bpm", 
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        if (_activityData.heartRate.maxValue != null) {
            dc.drawText(centerX + xPos + 40, centerY - 20, 
                Graphics.FONT_XTINY, 
                Lang.format("$1$", [_activityData.heartRate.maxValue]), 
                Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);        
        }
        if (_activityData.heartRate.minValue != null) {
            dc.drawText(centerX + xPos + 40, centerY, 
                Graphics.FONT_XTINY, 
                Lang.format("$1$", [_activityData.heartRate.minValue]), 
                Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);        
        }
    }

    function _drawAltitude(dc as Dc) as Void {
        var altText;
        var ascendText;

        if (_activityData.barometricAltitude.currentValue != null) { 
            altText = Lang.format("$1$m", 
                [_activityData.barometricAltitude.currentValue.format("%d")]);
            ascendText = Lang.format("+$1$m", 
                [_activityData.barometricAscent().format("%d")]);
        }
        else {
            altText = "---m";
            ascendText = "+---m";
        }

        var xPos = 70;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(xPos, centerY, Graphics.FONT_XTINY, altText, 
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_PINK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(xPos, centerY - 20, Graphics.FONT_XTINY, ascendText, 
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function _drawTemperature(dc as Dc) as Void {

        var temperatureText;
        if (_activityData.temperature.currentValue != null) {
            temperatureText = Lang.format("$1$°C", 
                [_activityData.temperature.currentValue.format("%.1f")]);
        }
        else {
            temperatureText = "---°C";
        }

        var xPos = 70;
        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(xPos, centerY + 20, Graphics.FONT_XTINY, temperatureText, 
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function _drawBatteryLevel(dc as Dc) as Void {
        if (_activityData.batteryLevel != null) {
            dc.setPenWidth(7);
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(centerX, centerY, centerX-3, 
                Graphics.ARC_COUNTER_CLOCKWISE, 240, 240 + 60);
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);

            var indicatorWidth = 60 * _activityData.batteryLevel / 100;
            dc.drawArc(centerX, centerY, centerX-3, 
                Graphics.ARC_COUNTER_CLOCKWISE, 240, 240 + indicatorWidth);
        }
    }

    function _drawSavingScreen(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX, centerY, Graphics.FONT_MEDIUM, 
            "ACTIVITY SAVED", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX, centerY + 35, Graphics.FONT_TINY, 
            "press any key\nto exit", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function _drawConfirmDiscardScreen(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX, centerY, Graphics.FONT_MEDIUM, 
            "Do you really\nwant to discard?\n", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX, centerY + 35, Graphics.FONT_TINY, 
            "press BACK\nto return", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function _drawDiscardingScreen(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX, centerY, Graphics.FONT_MEDIUM, 
            "ACTIVITY\nDISCARDED", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX, centerY + 35, Graphics.FONT_TINY, 
            "press any key\nto exit", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function _drawMenu(dc as Dc) as Void {
        if (_activityData.selectedMenuItem == MenuItem.RECORD_STOP) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_ORANGE);
        }
        else {
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        }

        dc.drawText(
            centerX, 30, Graphics.FONT_TINY, 
            "         SAVE & STOP         ", Graphics.TEXT_JUSTIFY_CENTER);

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

    private var screenWidth;
    private var screenHeight;
    private var centerX;
    private var centerY;
    private var _activityData;
}