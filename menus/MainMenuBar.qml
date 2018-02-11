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
            text: qsTr("Toggle Position")
            onTriggered: map.displayGPSCoord()
        }
    }
}
