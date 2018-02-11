import QtQuick 2.5
import QtLocation 5.6
import QtPositioning 5.2

MapQuickItem {
    id: gpsMarker
    anchorPoint.x: image.x / 2
    anchorPoint.y: image.y / 2

    PositionSource {
        id: gpsData
        active: true

        nmeaSource: "../res/sampleData/sampleGpsData.txt"
        updateInterval: 1000 // In milliseconds
        onPositionChanged: {
            console.log('Position changed')
        }
    }

    sourceItem: Image {
        id: image
        visible: true
        source: "../res/curGPS.png"
        anchors.fill: parent
    }

    Component.onCompleted: {
        console.log('Adding GPS image')
        coordinate = map.toCoordinate(gpsData.position.coordinate)
        map.addMapItem(gpsMarker)
    }
}
