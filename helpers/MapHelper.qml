import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2
import QtPositioning 5.8

Item {
    function loadPath(pathId) {
        var newMarkers = DatabaseMarker.readPathMarkers(pathId)
        // Order list by marker number
        console.log(newMarkers)
        newMarkers.sort(function(x, y) {
            return x[2] - y[2];
        });
        // Clean out markers already on map
        map.deleteAllMarkers()
        for (var i in newMarkers) {
            map.addMarker(QtPositioning.coordinate(newMarkers[i][0], newMarkers[i][1]))
        }
        console.log(map.markers)



    }

    function savePath(pathName) {
        // Put each portion of the current markers in a list to add them to db
        var lat = []
        var lon = []
        var marker_num = []
        for (var i in map.markers) {
            var marker = map.markers[i]
            lat.push(marker.coordinate.latitude)
            lon.push(marker.coordinate.longitude)
            marker_num.push(Number(i) + 1)
        }
        return DatabaseMarkerPath.createPath(pathName, lat, lon, marker_num)
    }
}
