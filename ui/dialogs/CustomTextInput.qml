import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Column {
    property string textStr: textInpt.displayText;
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
            id: textInpt
            focus: true
            anchors.fill: parent
            anchors.margins: 4
            mouseSelectionMode: TextInput.SelectCharacters
            selectByMouse: true
        }
    }
}
