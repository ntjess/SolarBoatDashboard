import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Dialog {
    property string nameStr: newPathInpt.textStr;
    height: 120
    title: "New Path Name"
    standardButtons: StandardButton.Save | StandardButton.Cancel

    CustomTextInput {
        id: newPathInpt
    }
}
