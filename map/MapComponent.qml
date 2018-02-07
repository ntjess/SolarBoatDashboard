import QtQuick 2.5
import QtLocation 5.9
import QtQuick.Controls 2.2

Map {
    property int markerCounter: 0 // counter for total amount of markers. Resets to 0 when number of markers = 0
    property variant markers
    property variant mapItems
    signal createMarker

    plugin: Plugin {
        name: "osm"
    }

    MouseArea {
        anchors.fill: parent

        onPressAndHold: {
            var coords = map.toCoordinate(Qt.point(mouse.x, mouse.y))
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

    Component.onCompleted: {
        console.log('map component completed')
        markers = []
        mapItems = []
    }
}
