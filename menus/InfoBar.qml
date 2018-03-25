import QtQuick 2.5
import QtQuick.Controls 2.3

import "../helpers/"

Rectangle {
    // Expose helper functions to other qml objects
    property alias helper: infoHelper

    // Allow the helper to modify text strings
    property string guideTxt: "N/A"
    property string velocityTxt: "N/A"
    property string remainingDistTxt: "N/A"

    id: info
    color: "light grey"
    width: parent.width
    height: 50

    InfoHelper {
        id: infoHelper
    }

    Text {
        id: nextGuide
        anchors.left: parent.left
        anchors.leftMargin: 10
        text: guideTxt
        font.pointSize: 14
    }

    Text {
        id: reminingDist
        anchors.left: nextGuide.right
        anchors.leftMargin: 10
        text: remainingDistTxt
        font.pointSize: 14
    }

    Text {
        id: velocity
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        text: velocityTxt
        font.pointSize: 14
    }
}
