import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Popup {
    property var options: ["Speed", "Time", "Laps Completed", "Laps Remaining"]

    width: 500 //root.width
    height: 500 //root.height - appMainMenu.height - info.height
    x: info.x
    margins: info.height + appMainMenu.height
    modal: true
    focus: true

    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    Column {
        Repeater {
            height: 400
            width: 400
            model: options
            clip: true
            delegate: optionDelegate
        }

        Component {
            id: optionDelegate

            Rectangle {
                color: "green"
                height: 50
                width: 50
                Text {
                    text: modelData + " Test"
                }
            }
        }
    }
}
