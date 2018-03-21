import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2
import QtPositioning 5.8

Item {
    function updateRoute() {
        var pathCoords = []
        for (var i in map.markers) {
            pathCoords.push(map.markers[i].coordinate)
        }
        if (map.raceType == "Circular") {
            pathCoords.push(map.markers[0].coordinate)
        }

        mapLinePath.path = pathCoords
    }

    function activateGps() {
        gpsData.active = true
    }

    function addMarker(coords) {
        // If markers isn't initialized, make it
        map.markers = map.markers || []
        var count = map.markers.length
        markerCounter++
        var marker = Qt.createQmlObject('import "../map"; Marker {}', map)
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
        updateRoute()
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
        updateRoute()
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
        // Shouldn't do anything if there are no markers
        if (map.markerCounter == 0)
            return
        var visibility = map.markers[0].visible
        for (var el in map.markers) {
            map.markers[el].visible = !visibility
        }
    }

    function toggleRoute() {
        if (mapLinePath.visible == true) {
            mapLinePath.visible = false
        } else {
            mapHelper.updateRoute()
            mapLinePath.visible = true
        }
    }
    function loadPath(pathId) {
        var newMarkers = DatabaseMarker.readPathMarkers(pathId)
        // Order list by marker number
        console.log(newMarkers)
        newMarkers.sort(function (x, y) {
            return x[2] - y[2]
        })
        // Clean out markers already on map
        deleteAllMarkers()
        for (var i in newMarkers) {
            addMarker(QtPositioning.coordinate(newMarkers[i][0],
                                               newMarkers[i][1]))
        }
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

    function updateCircularDist() {
        if (!mapLinePath.visible) {
            // No path. Don't calculate anything
            return
        }
        var totDist = 0
        var lapDist = 0

        // Only find total lap distance if there is < 1 lap remaining. Else it
        // is just a waste
        if (map.numLaps - map.lapsCompleted > 1) {
            lapDist += totCircularLapDist()
            // Increase total distance by the number of completely untraversed laps
            totDist += lapDist * (map.numLaps - map.lapsCompleted - 1)
        }

        var gpsCoord = gpsData.position.coordinate
        var curDist = gpsCoord.distanceTo(
                    map.markers[map.currentTarget].coordinate)
        // Find remaining distance in current lap. If next marker is 0, then the
        // current lap is finishing up. No need to iterate
        if (map.currentTarget !== 0) {
            // Init lap distance with dist from end to beginning
            totDist += map.markers[map.markerCounter - 1].coordinate.distanceTo(
                        map.markers[0].coordinate)
            for (var i = map.currentTarget; i < map.markerCounter - 1; i++) {
                // This will add all distance from end point to current objective
                totDist += map.markers[i].coordinate.distanceTo(
                            map.markers[i + 1].coordinate)
            }
        }
        // This will happen if GPS is close to another marker and there is still at least
        // one more waypoint past the objective
        if (totDist != 0 && curDist < map.distanceThreshold) {
            // This will account for lap wrap around. If current target is 0,
            // we just finished another lap
            if (map.currentTarget === 0) {
                map.lapsCompleted++;
            }

            map.currentTarget = (map.currentTarget + 1) % map.markerCounter
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

    function totCircularLapDist() {
        // Init lap distance with dist from end to beginning
        var lapDist = map.markers[map.markerCounter - 1].coordinate.distanceTo(
                    map.markers[0].coordinate)
        // Fill in the rest of the lap to get total lap distance
        for (var i = 0; i < map.markerCounter - 1; i++) {
            // Find the distance to end of markers
            lapDist += map.markers[i].coordinate.distanceTo(
                        map.markers[i + 1].coordinate)
        }
        return lapDist
    }

    function backForthDistRemaining() {}

    function displayGPSCoord() {
        console.log(currentLoc.gpsData.position.coordinate)
    }

    function snapUnsnapGPS() {
        map.followingGPS = !map.followingGPS
        map.center = (map.followingGPS ? gpsData.position.coordinate : map.center)
    }

    function setNewTarget(newTarget) {
        map.currentTarget = newTarget
        map.updateDistances()
    }
}
