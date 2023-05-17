import Toybox.Lang;

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
}
