import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

import "../helpers"

MenuBar {
    id: mainMenu
    signal loadPath(int pathId)

    onLoadPath: mapHelper.loadPath(pathId)
    MainMenuHelper {
        // Gain access to menu helper functions
        id: mainMenuHelper
    }

    MessageDialog {
        id: deleteMarkersDialog
        title: "Confirm Delete"
        text: "Are you sure you want to do this?"
        standardButtons: StandardButton.Cancel | StandardButton.Yes
        onYes: map.deleteAllMarkers()
    }

    Dialog {
        id: pathNameDialog
        height: 120
        title: "New Path Name"
        standardButtons: StandardButton.Save | StandardButton.Cancel

        Column {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 3

            Rectangle {
                height: 25
                width: parent.width
                color: "white"
                border.width: 1
                border.color: "black"

                TextInput {
                    id: pathName
                    anchors.fill: parent
                    anchors.margins: 4
                    mouseSelectionMode: TextInput.SelectCharacters
                    selectByMouse: true
                }
            }
        }

        onAccepted: {
            var id = mapHelper.savePath(pathName.displayText)
            var pathData = [[id], [pathName.displayText]]
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
            on
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
