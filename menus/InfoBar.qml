import QtQuick 2.5
import QtQuick.Controls 2.3

Rectangle {
    color: "light grey"
    width: parent.width
    height: 50

    Text {
        id: nextMarkerDistText
        anchors.left: parent.left
        anchors.leftMargin: 10
        text: "Distance to next marker: " + map.distToNextMarker + " m"
        font.pointSize: 14
    }

    Text {
        id: reminingDistText
        anchors.left: nextMarkerDistText.right
        anchors.leftMargin: 10
        text: "Total remaining distance: " + map.remainingDistance + " m"
        font.pointSize: 14
    }
}