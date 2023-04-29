import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class ActivityDisplay extends WatchUi.Drawable {
    function initialize(params as Object) {
        Drawable.initialize(params);    
    }

    function draw(dc as Dc) as Void {
        // Draw the move bar here

        var screenSize = 240;

        var x = screenSize / 2;
        var y = screenSize / 2;
        var font = Graphics.FONT_NUMBER_THAI_HOT;
        var text = "12:34";
        var justification = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
        dc.drawText(x, y, font, text, justification);
    }
}