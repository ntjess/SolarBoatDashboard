import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

// This gets instantiated in the MainMenuBar, so that will be the parent.
Item {
    function addToLoadPaths(pathData) {
        // We have two lists in pathData: ids, namse. Parse them into menu actions
        for (var i in pathData[0]) {
            // IdAction is simply an action with an additional property that
            // holds the path id
            var actionId = pathData[0][i];
            var curAction = Qt.createQmlObject('import "../menus"; IdAction {onTriggered: mainMenu.loadPath(' + actionId + ')}', dbPaths)
            curAction.text = pathData[1][i]
            // Action is now ready to place in menu
            dbPaths.addAction(curAction)
        }
    }
}
