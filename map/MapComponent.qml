import QtQuick 2.5
import QtLocation 5.9
import QtPositioning 5.6
import QtQuick.Controls 2.2

import "../helpers"

Map {
    // Markers
    property int markerCounter: 0
    property variant markers

    // Path and distance
    property bool finishedRace: false
    property int distToNextMarker: 0
    property int currentTarget: 1 // What marker the GPS is aiming for next
    // Tolerance (m) acceptable to consider current location as reaching the next marker
    property int distanceThreshold: 15
    property int remainingDistance: 0
    property double speed: 0 // in m/s

    // Race setting variables
    property string raceType: "Back-Forth"
    property int numLaps: 0
    property int lapsCompleted: 0

    // Snap/unsnap GPS
    property bool followingGPS: false
    property int currentMarker: -1
    property variant leeuwarden: QtPositioning.coordinate(53.2012, 5.7999)

    // Expose the map helper to other qml components
    property alias helper: mapHelper

    plugin: Plugin {
        name: "osm"
    }
    center: leeuwarden
    zoomLevel: 15

    MapHelper {
        id: mapHelper
    }

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
            !finishedRace & helper.updateCircularDist()
            map.speed = position.speed // in m/s
            if (map.followingGPS) {
                map.center = position.coordinate
            }
        }
    }

    CurrentLocation {
    }

    MapQuickItem {
        sourceItem: Text {
            text: "A"
            color: "red"
            font.bold: true
            styleColor: "#ECECEC"
            style: Text.Outline
            font.pointSize: 15
        }
        coordinate: QtPositioning.coordinate(53.20370367, 5.80089859) // GPS start
        anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)
    }

    MapQuickItem {
        sourceItem: Text {
            text: "B"
            color: "red"
            font.bold: true
            styleColor: "#ECECEC"
            style: Text.Outline
            font.pointSize: 15
        }
        coordinate: QtPositioning.coordinate(53.20285297, 5.80311816)
        anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)
    }

    MapQuickItem {
        sourceItem: Text {
            text: "C"
            color: "red"
            font.bold: true
            styleColor: "#ECECEC"
            style: Text.Outline
            font.pointSize: 15
        }
        coordinate: QtPositioning.coordinate(53.20224578, 5.80162871)
        anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)
    }

    MapQuickItem {
        sourceItem: Text {
            text: "D"
            color: "red"
            font.bold: true
            styleColor: "#ECECEC"
            style: Text.Outline
            font.pointSize: 15
        }
        coordinate: QtPositioning.coordinate(53.20346821, 5.80067635)
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
            mapHelper.addMarker(coords)
        }
    }

    Component.onCompleted: {
        markers = []
    }
}
