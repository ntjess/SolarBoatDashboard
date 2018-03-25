import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Popup {
    width: 500 //root.width
    height: 100 //root.height - appMainMenu.height - info.height
    x: info.x
    margins: info.height + appMainMenu.height
    modal: true
    focus: true

    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape

    Column {
        width: parent.width
        Row {
            Label {
                height: parent.height
                text: qsTr("Race Type: ")
            }
            ComboBox {
                // TODO: change to enumeration
                model: ["Back-Forth", "Circular"]
                onCurrentTextChanged: {
                    map.isCircularRace = (currentText === "Circular" ? true : false)
                    map.helper.updateRoute()
                }
            }
        }
        Row {
            Label {
                height: parent.height
                text: qsTr("Number of Laps: ")
            }
            CustomNumberInput {
                onNumChanged: map.numLaps = num
            }
        }
    }
}
