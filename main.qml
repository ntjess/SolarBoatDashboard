import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick 2.5
import QtQuick.Controls 2.3
import QtLocation 5.6

import "map"
import "menus"
import "helpers"


ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Dashboard")

    menuBar: appMainMenu

    MainMenuBar {
        id: appMainMenu
    }

    InfoBar {
        id: info
    }

    MapComponent {
        id: map
        anchors.fill: parent
        anchors.topMargin: info.height
        MapHelper {
            id: mapHelper
        }
    }
}
