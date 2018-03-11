import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

import "../helpers"
import "../dialogs"

MenuBar {
    id: mainMenu
    signal loadPath(int pathId)

    onLoadPath: mapHelper.loadPath(pathId)
    MainMenuHelper {
        // Gain access to menu helper functions
        id: mainMenuHelper
    }

    DeleteDialog {
        id: deleteMarkersDialog
        onYes: map.deleteAllMarkers()
    }

    NewPathDialog {
        id: pathNameDialog
        onAccepted: {
            var id = mapHelper.savePath(pathNameDialog.newPathName)
            var pathData = [[id], [pathNameDialog.newPathName]]
            mainMenuHelper.addToLoadPaths(pathData)
        }
    }

    Menu {
        id: toolsMenu
        title: qsTr("Path Tools")
        Action {
            text: qsTr("Show/Hide Route")
            onTriggered: map.toggleRoute()
        }
        Action {
            text: qsTr("Save Path")
            onTriggered: pathNameDialog.open()
        }

        Action {
            text: qsTr("Track Distance")
            onTriggered: map.updateDistances()
        }
    }

    Menu {
        id: dbPaths
        title: qsTr("Load Path")
        Component.onCompleted: {
            mainMenuHelper.addToLoadPaths(DatabaseMarkerPath.readAllPaths())
        }
    }

    Menu {
        id: markerTools
        title: qsTr("Marker Tools")
        Action {
            text: qsTr("Show/Hide Markers")
            onTriggered: map.toggleMarkers()
        }

        MenuSeparator {
        }
        Action {
            text: qsTr("Delete All Markers")
            onTriggered: deleteMarkersDialog.open()
        }
    }

    Menu {
        id: mapTools
        title: qsTr("Map Tools")
        Action {
            text: qsTr("Snap/Unsnap to GPS")
            onTriggered: map.snapUnsnapGPS()
        }
    }

    Rectangle {
        color: "light green"
        parent: mainMenu
        height: parent.height - 10
        width: 100
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 10
        anchors.topMargin: 5
        radius: 5

        Text {
            anchors.centerIn: parent
            text: "Start GPS"
            color: "white"
            font.pointSize: 12
        }

        MouseArea {
            anchors.fill: parent
            onClicked: map.activateGPS()
        }
    }
}
