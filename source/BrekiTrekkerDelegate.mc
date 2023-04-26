import Toybox.Lang;
import Toybox.WatchUi;

class BrekiTrekkerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new BrekiTrekkerMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}