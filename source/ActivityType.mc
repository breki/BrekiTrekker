import Toybox.Activity;
import Toybox.Lang;


class ActivityType {
    public function initialize(
        nameShort as String, nameLong as String, sport as Activity.Sport) {
        self.nameShort = nameShort;
        self.nameLong = nameLong;
        self.sport = sport;
    }

    var nameShort as String;
    var nameLong as String;
    var sport as Activity.Sport;
}
