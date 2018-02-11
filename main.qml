import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick 2.5
import QtQuick.Controls 2.3
import QtLocation 5.6

import "map"
import "menus"

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Dashboard")

    menuBar: appMainMenu

    MainMenuBar {
        id: appMainMenu
        onGenerateRoute: map.calculateMarkerRoute()
    }

    MapComponent {
        id: map
        anchors.fill: parent
    }
}
