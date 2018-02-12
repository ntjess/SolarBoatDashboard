import QtQuick 2.5
import QtQuick.Controls 2.3

MenuBar {

    id: mainMenu
    Menu {
        id: toolsMenu
        title: qsTr("Tools")
        Action {
            text: qsTr("Generate Route")
            onTriggered: map.generateRoute()
        }
        Action {
            text: qsTr("Delete Route")
            onTriggered: map.deleteRoute()
        }
        MenuSeparator {}
        Action {
            text: qsTr("Show/Hide position")
            onTriggered: map.displayGPSCoord()
        }
    }

    MenuBarItem {
        text: qsTr("Snap/Unsnap GPS")
        onTriggered: {
            //map.toggleFollowGPS()
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
