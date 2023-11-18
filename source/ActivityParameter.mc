import Toybox.Lang;
import Toybox.Position;

class ActivityParameter {
    function setValue(value as Number or Null) {
        currentValue = value;

        if (currentValue != null) {
            if (minValue == null || currentValue < minValue) {
                minValue = currentValue;
            }
            if (maxValue == null || currentValue > maxValue) {
                maxValue = currentValue;
            }

            var x = minCurrentDiff();
            if (x != null 
                && (maxMinCurrentDiff == null || x > maxMinCurrentDiff)) {
                maxMinCurrentDiff = x;
            }
        }
    }

    function minMaxDiff() as Number or Null {
        if (minValue != null && maxValue != null) {
            return maxValue - minValue;
        }
        else {
            return null;
        }
    }

    function minCurrentDiff() as Number or Null {
        if (minValue != null && currentValue != null) {
            return currentValue - minValue;
        }
        else {
            return null;
        }
    }

    var currentValue as Number or Null;
    var minValue as Number or Null;
    var maxValue as Number or Null;
    var maxMinCurrentDiff as Number or Null;
}


class ActivityLocation {
    function initialize(location as Location, elevation as Float) {
        self.location = location;
        self.elevation = elevation;
    }

    function distanceTo (anotherLocation as ActivityLocation) as Float {
        return distance(location, anotherLocation.location);
    }

    var location as Location;   
    var elevation as Float;
}
