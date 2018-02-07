import QtQuick 2.5
import QtQuick.Controls 2.3

MenuBar {
    Menu {
        id: toolsMenu
        title: qsTr("Tools")
        Action {
            text: qsTr("Generate Route")
        }
    }
}
