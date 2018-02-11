import QtQuick 2.5
import QtLocation 5.6
import QtPositioning 5.2

MapQuickItem {
    id: gpsMarker
    anchorPoint.x: image.x / 2
    anchorPoint.y: image.y / 2
    opacity: 1.0

    sourceItem: Image {
        id: image
        source: "../res/curGPS.png"
        anchors.fill: parent
    }

    Component.onCompleted: {
        console.log('Adding GPS image')
        coordinate = map.toCoordinate(gpsData.position.coordinate)
    }
}
