import Toybox.Lang;
import Toybox.Math;
import Toybox.Position;

// Calculate distance (in meters) between two geographical points.
function distance(loc1 as Location, loc2 as Location) as Float {
    var R = 6371000; // meters

    var loc1Rad = loc1.toRadians();
    var loc2Rad = loc2.toRadians();

    var lat1 = loc1Rad[0];
    var lon1 = loc1Rad[1];
    var lat2 = loc2Rad[0];
    var lon2 = loc2Rad[1];
 
    var dLat = lat2-lat1;
    var dLon = lon2-lon1; 
    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(lat1) * Math.cos(lat2) * 
        Math.sin(dLon/2) * Math.sin(dLon/2); 
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    
    return R * c;
}