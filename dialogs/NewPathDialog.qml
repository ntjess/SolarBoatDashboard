import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Dialog {
    property alias nameStr: pathName;

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
                focus: true
                anchors.fill: parent
                anchors.margins: 4
                mouseSelectionMode: TextInput.SelectCharacters
                selectByMouse: true
            }
        }
    }
}
