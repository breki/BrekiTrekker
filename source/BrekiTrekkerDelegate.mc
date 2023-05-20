import Toybox.Lang;
import Toybox.Position;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Time;
import Toybox.Timer;
import Toybox.WatchUi;
using Toybox.Activity as Activity;

class BrekiTrekkerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();

        Position.enableLocationEvents(
            Position.LOCATION_CONTINUOUS, method(:onPosition));

        Sensor.setEnabledSensors(
            [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE]);
        Sensor.enableSensorEvents(method(:onSensor));

        activityTimer = new Timer.Timer();
        var repeat = true; // the Timer will repeat until stop() is called
        activityTimer.start(method(:_updateActivityView), 1000, repeat);
    }

    function onMenu() as Boolean {
        WatchUi.pushView(
            new Rez.Menus.MainMenu(), 
            new BrekiTrekkerMenuDelegate(), 
            WatchUi.SLIDE_UP);
        return true;
    }

    function onPosition(info as Position.Info) as Void {
        activityData.setGpsAltitude(info.altitude);
    }

    function onSensor(info as Sensor.Info) as Void {
        activityData.setHeartRate(info.heartRate);
        activityData.setBarometricAltitude(info.altitude);
        activityData.setTemperature(info.temperature);
    }

    // on the SELECT button press
    function onSelect() as Boolean {
        activityData.onSelectButton();
        return true;
    }

    function onBack() as Boolean {
        activityData.onBackButton();

        _updateActivityView();

        return true;
    }

    function onNextPage() as Boolean {
        var refreshDisplay = activityData.onNextPageButton();
        if (refreshDisplay) {
            _updateActivityView();
        }

        return true;
    }

    function onPreviousPage() as Boolean {
        var refreshDisplay = activityData.onPreviousPageButton();
        if (refreshDisplay) {
            _updateActivityView();
        }

        return true;
    }

    function _updateActivityView() as Void {
        var systemStats = System.getSystemStats();
        activityData.batteryLevel = systemStats.battery;

        var activityInfo = Activity.getActivityInfo();
        activityData.elapsedDistance = activityInfo.elapsedDistance;

        activityView.updateView(activityData);
    }

    private var activityData = new ActivityData();
    private var activityTimer;
    private var activityView = getApp().getActivityView();
}