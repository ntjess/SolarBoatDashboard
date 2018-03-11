import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

import "../helpers"
import "../dialogs"

Action {
    DeleteDialog {
        onYes: {
            var success = DatabaseMarkerPath.deletePath(actionId)
            if (!success) {
                console.log("Delete failed.");
            }
    }

    property int actionId

    MouseArea {
        anchors.fill: parent
        onPressAndHold: deleteDialog.open()
    }

    onTriggered: mainMenu.loadPath(actionId)
}
