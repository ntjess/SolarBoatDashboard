import QtQuick 2.5
import QtQuick.Controls 2.3

MenuBar {
    signal generateRoute

    id: mainMenu
    Menu {
        id: toolsMenu
        title: qsTr("Tools")
        Action {
            text: qsTr("Generate Route")
            onTriggered: mainMenu.generateRoute()
        }
    }
}
