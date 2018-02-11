import QtQuick 2.5
import QtQuick.Controls 2.3

MenuBar {
    signal generateRoute
    signal deleteRoute

    id: mainMenu
    Menu {
        id: toolsMenu
        title: qsTr("Tools")
        Action {
            text: qsTr("Generate Route")
            onTriggered: mainMenu.generateRoute()
        }
        Action {
            text: qsTr("Delete Route")
            onTriggered: mainMenu.deleteRoute()
        }
    }
}
