import QtQuick 2.5
import QtLocation 5.9
import QtPositioning 5.6
import QtQuick.Controls 2.2

Map {
    // Markers
    property int markerCounter: 0
    property variant markers

    // Path and distance
    property bool finishedRace: false
    property int distToNextMarker: 0
    property int currentTarget: 0 // What marker the GPS is aiming for next
    // Tolerance (m) acceptable to consider current location as reaching the next marker
    property int distanceThreshold: 15
    property int remainingDistance: 0
    property double speed: 0 // in m/s

    // Snap/unsnap GPS
    property bool followingGPS: false
    property int currentMarker: -1
    property variant leeuwarden: QtPositioning.coordinate(53.2012, 5.7999)

    plugin: Plugin {
        name: "osm"
    }
    center: leeuwarden
    zoomLevel: 15

    MapPolyline {
        id: mapLinePath
        line.width: 2
        line.color: 'green'
        visible: false // This will change once a route is added
    }

    PositionSource {
        id: gpsData
        active: false
        nmeaSource: "../res/sampleData/output.nmea"
        updateInterval: 3000 // In milliseconds
        onPositionChanged: {
            !finishedRace & map.updateDistances()
            map.speed = position.speed // in m/s
            if (map.followingGPS) {
                map.center = position.coordinate
            }
        }
    }

    CurrentLocation {
    }

    MapQuickItem {
        sourceItem: Text{
            text: "A"
            color:"red"
            font.bold: true
            styleColor: "#ECECEC"
            style: Text.Outline
            font.pointSize: 15
        }
        coordinate: QtPositioning.coordinate(53.2028, 5.788717) // GPS start
        anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)
    }

    MapQuickItem {
        sourceItem: Text{
            text: "B"
            color:"red"
            font.bold: true
            styleColor: "#ECECEC"
            style: Text.Outline
            font.pointSize: 15
        }
        coordinate: QtPositioning.coordinate(53.204367, 5.78875) // GPS end
        anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)
    }

    MouseArea {
        anchors.fill: parent

        onPressAndHold: {
            // For some reason, the coordinates are offset from the click location.
            // Rectify by adding 'fudge factor'
            /*var fudgeX = 0.0001;
            var fudgeY = fudgeX;*/
            var coords = map.toCoordinate(Qt.point(mouse.x, mouse.y))
            addMarker(coords)
        }
    }

    function activateGPS() {
        gpsData.active = true
    }

    function addMarker(coords) {
        // If markers isn't initialized, make it
        map.markers = map.markers || []
        var count = map.markers.length
        markerCounter++
        var marker = Qt.createQmlObject('Marker {}', map)
        map.addMapItem(marker)
        marker.z = map.z + 1
        marker.coordinate = coords

        //update list of markers
        var myArray = []
        for (var i = 0; i < count; i++) {
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray
    }

    function deleteMarker() {
        //update list of markers
        var myArray = []
        var count = map.markers.length
        for (var i = 0; i < count; i++) {
            if (i != map.currentMarker)
                myArray.push(map.markers[i])
        }

        map.removeMapItem(map.markers[map.currentMarker])
        map.markers[map.currentMarker].destroy()
        map.markers = myArray
        map.markerCounter--
        map.deleteRoute()
    }

    function deleteAllMarkers() {
        var newMarkers = []
        var count = map.markers.length
        for (var i = 0; i < count; i++) {
            map.removeMapItem(map.markers[i])
            map.markers[i].destroy()
        }
        map.markers = newMarkers
        map.markerCounter = 0
        mapLinePath.visible = false
    }

    function toggleMarkers() {
        var visibility = map.markers[0].visible;
        for (var el in map.markers) {
            map.markers[el].visible = !visibility
        }
    }

    function toggleRoute() {
        if (mapLinePath.visible == true) {
            mapLinePath.visible = false
        } else {
            var pathCoords = []
            for (var i in map.markers) {
                pathCoords.push(map.markers[i].coordinate)
            }
            mapLinePath.path = pathCoords
            mapLinePath.visible = true
        }
    }

//    function deleteRoute() {
//        mapLinePath.visible = false
//        map.currentTarget = 0
//        map.remainingDistance = 0
//        map.distToNextMarker = 0
//    }

    function displayGPSCoord() {
        console.log(currentLoc.gpsData.position.coordinate)
    }

    function snapUnsnapGPS() {
        map.followingGPS = !map.followingGPS
        map.center = (map.followingGPS ? gpsData.position.coordinate : map.center)
    }

    function updateDistances() {
        if (!mapLinePath.visible) {
            // No path. Don't calculate anything
            return
        }

        var gpsCoord = gpsData.position.coordinate
        var curDist = gpsCoord.distanceTo(
                    map.markers[map.currentTarget].coordinate)
        // Work backwards to find total remaining distance
        var totDist = 0
        for (var i = map.markerCounter - 1; i > map.currentTarget; i--) {
            // This will add all distance from end point to current objective
            totDist += map.markers[i].coordinate.distanceTo(
                        map.markers[i - 1].coordinate)
        }
        // This will happen if GPS is close to another marker and there is still at least
        // one more waypoint past the objective
        if (totDist != 0 && curDist < map.distanceThreshold) {
            map.currentTarget++
            curDist = gpsCoord.distanceTo(map.markers[map.currentTarget])
        } else if (curDist < map.distanceThreshold) {
            // Within tolerance of final marker. Consider race finished
            map.finishedRace = true
            return
        }

        totDist += curDist
        // Total distance should now be accurate regardless of whether a new objective was set
        map.remainingDistance = totDist
        map.distToNextMarker = curDist
    }

    function setNewTarget(newTarget) {
        map.currentTarget = newTarget
        map.updateDistances()
    }

    function saveMarkers(pathName) {
        // Put each portion of the current markers in a list to add them to db
        var lat = [];
        var lon = [];
        var marker_num = [];
        for (var i in map.markers) {
            var marker = map.markers[i];
            lat.push(marker.coordinate.latitude)
            lon.push(marker.coordinate.longitude)
            marker_num.push(Number(i)+1)
        }
        DatabaseMarkerPath.createPath(pathName, lat, lon, marker_num)
    }

    Component.onCompleted: {
        markers = []
    }
}
