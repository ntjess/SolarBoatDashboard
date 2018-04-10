import QtQuick 2.5
import QtQuick.Controls 2.3

import "../helpers/"
import "../dialogs/"

Rectangle {
  // Expose helper functions to other qml objects
  property alias helper: infoHelper
  property alias displayItems: infoPopup

  // Allow the helper to modify text strings
  property string guideTxt: "Next Guide: N/A"
  property string velocityTxt: "Velocity: N/A"
  property string remainingDistTxt: "Remaining distance: N/A"
  // Number of information pieces to show to the user
  property int infoCount: 0

  id: info
  color: "light grey"
  width: parent.width
  // Scale height if lots of items are shown
  height: 50 + (25 * Math.round(infoCount / 4))

  InfoHelper {
    id: infoHelper
  }

  InfoPopup {
    id: infoPopup
  }

  Text {
    id: nextGuide
    anchors.left: parent.left
    anchors.leftMargin: 10
    text: guideTxt
    font.pointSize: 14
  }

  Text {
    id: reminingDist
    anchors.left: nextGuide.right
    anchors.leftMargin: 10
    text: remainingDistTxt
    font.pointSize: 14
  }

  Text {
    id: velocity
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10
    anchors.leftMargin: 10
    text: velocityTxt
    font.pointSize: 14
  }

  Button {
    id: skipCurTargetButton
    visible: infoHelper.canIncTarget
    anchors.right: parent.right
    anchors.rightMargin: 10
    anchors.topMargin: 5
    // Needed to make text white
    contentItem: Text {
      color: "white"
      text: "Skip target"
    }
    background: Rectangle {
      anchors.fill: parent
      color: "light green"
      radius: 5
    }
    onPressed: infoHelper.forceInc = true
  }

  Text {
    visible: infoHelper.canIncTarget
    id: curTargetTxt
    text: "Current target: " + (Number(map.curTarget) + 1)
    anchors.top: skipCurTargetButton.bottom
    anchors.right: skipCurTargetButton.right
    font.pointSize: 14
  }
}
