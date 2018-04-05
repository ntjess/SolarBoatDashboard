import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Popup {
    property var options: ["Speed", "Time", "Laps Completed", "Laps Remaining",
        "Distance Remaining", "Distance Covered"]

    width: 500 //root.width
    height: root.height - appMainMenu.height - info.height
    leftMargin: Math.floor((root.width - infoPopup.width) / 2)
    topMargin: appMainMenu.height
    modal: true
    focus: true

    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    // Populates a popup of information the user can choose to see
    GridView {
        anchors.fill: parent
        anchors.centerIn: parent
        cellWidth: 150
        cellHeight: 50
        model: options
        clip: true

        delegate: optionDelegate
    }

    Component {
        id: optionDelegate

        CheckBox {
            text: modelData
        }
    }
}
