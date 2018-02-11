import QtQuick 2.5
import QtLocation 5.9
import QtQuick.Controls 2.2

Map {
    // counter for total amount of markers. Resets to 0 when number of markers = 0
    property int markerCounter: 0
    property variant markers
    property variant mapItems
    property int pressX: -1
    property int pressY: -1
    property int currentMarker: -1
    signal createMarker

    plugin: Plugin {
        name: "osm"
    }

    MapPolyline {
        id: mapLinePath
        line.width: 2
        line.color: 'green'
    }

    RouteModel {
        id: routeModel
        plugin: map.plugin
        query: RouteQuery {
            id: routeQuery
        }
        onStatusChanged: {
            if (status == RouteModel.Ready) {
                switch (count) {
                case 0:
                    // technically not an error
                    map.routeError()
                    break
                case 1:
                    map.showRouteList()
                    break
                }
            } else if (status == RouteModel.Error) {
                map.routeError()
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressAndHold: {
            // For some reason, the coordinates are offset from the click location.
            // Rectify by adding 'fudge factor'
            /*var fudgeX = 0.0001;
            var fudgeY = fudgeX;*/
            var coords = map.toCoordinate(Qt.point(mouse.x, mouse.y))
            console.log(mouse.x + ", " + mouse.y)
            addMarker(coords)
        }
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
    }

    function calculateMarkerRoute() {
        console.log('Calculated route')
        var pathCoords = []
        for (var i in map.markers) {
            pathCoords.push(map.markers[i].coordinate)
        }
        mapLinePath.path = pathCoords
        mapLinePath.visible = true;
    }

    function deleteRoute() {
        mapLinePath.visible = false
    }

    Component.onCompleted: {
        console.log('map component completed')
        markers = []
        mapItems = []
    }
}
