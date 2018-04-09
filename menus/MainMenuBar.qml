import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

import "../helpers"
import "../dialogs"

MenuBar {
    id: mainMenu

    MenuHelper {
        // Gain access to menu helper functions
        id: menuHelper
    }

    DeleteDialog {
        id: deleteMarkersDialog
        onYes: map.helper.deleteAllMarkers()
    }

    NewPathDialog {
        id: pathNameDialog
        onAccepted: {
            var id = map.helper.savePath(pathNameDialog.nameStr)
            var pathData = [[id], [nameStr]]
            menuHelper.addToLoadPaths(pathData)
        }
    }

    RaceSettingsPopup {
        id: settingsPopup
    }

    InfoPopup {
        id: infoPopup
    }

    Menu {
        id: toolsMenu
        title: qsTr("Path Tools")
        Action {
            text: qsTr("Show/Hide Route")
            onTriggered: map.helper.toggleRoute()
        }
        Action {
            text: qsTr("Save Path")
            onTriggered: {
                pathNameDialog.open()
                pathNameDialog.nameStr.focus = true
            }
        }
    }

    Menu {
        id: dbPaths
        title: qsTr("Load Path")
        Component.onCompleted: {
            menuHelper.addToLoadPaths(DBPath.readAllPaths())
        }
    }

    Menu {
        id: markerTools
        title: qsTr("Marker Tools")
        Action {
            text: qsTr("Show/Hide Markers")
            onTriggered: map.helper.toggleMarkers()
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
            onTriggered: map.helper.snapUnsnapGPS()
        }
    }

    Menu {
        id: settings
        title: qsTr("Settings")
        Action {
            text: qsTr("Race settings")
            onTriggered: settingsPopup.open()
        }
        Action {
            text: qsTr("Display Items")
            onTriggered: infoPopup.open()
        }
    }

    Rectangle {
        id: rectangle
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
            text: "Start race"
            color: "white"
            font.pointSize: 12
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                map.helper.activateGps()
                map.curTarget = 1
                map.lapsCompleted = 0
                map.finishedRace = false
                map.upDir = true
            }
        }
    }
}
