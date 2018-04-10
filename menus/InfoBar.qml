import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import "../helpers/"
import "../dialogs/"

Rectangle {
  // Expose helper functions to other qml objects
  property alias helper: infoHelper
  property alias displayItems: infoPopup
  // hack-ey way of getting at checkboxes in the popup
  property var checkBoxes: infoPopup.optionGrid.children[0].children

  // Allow the helper to modify text strings
  property string guideTxt: "Next Guide: N/A"
  property string velocityTxt: "Velocity: N/A"
  property string remainingDistTxt: "Remaining distance: N/A"
  // Number of information pieces to show to the user
  property int infoCount: 0

  id: info
  color: "light grey"
  width: parent.width
  // Scale height if lots of items are shown. 3 displays per row
  height: childrenRect.height

  InfoHelper {
    id: infoHelper
  }

  InfoPopup {
    id: infoPopup
  }

  GridLayout {
    id: displayGrid
    width: parent.width - 100
    columns: 2

    Text {
      text: "DONE!"
      font.pointSize: 14
      visible: map.finishedRace
    }

    Text {
      id: nextGuide
      text: guideTxt
      font.pointSize: 14

      visible: checkBoxes[3].checked && !map.finishedRace
    }

    Text {
      id: reminingDist
      text: remainingDistTxt
      font.pointSize: 14

      visible: checkBoxes[4].checked && !map.finishedRace
    }

    Text {
      id: velocity
      text: velocityTxt
      font.pointSize: 14

      visible: checkBoxes[0].checked && !map.finishedRace
    }

    Text {
      id: lapsCompleted
      text: "Laps completed: " + map.lapsCompleted
      font.pointSize: 14

      visible: checkBoxes[1].checked && !map.finishedRace
    }

    Text {
      id: lapsRemaining
      text: "Laps remaining: " + (map.numLaps - map.lapsCompleted - 1)
      font.pointSize: 14

      visible: checkBoxes[2].checked && !map.finishedRace
    }
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
    id: curTargetTxt
    visible: infoHelper.canIncTarget
    text: "Target #: " + (Number(map.curTarget) + 1)
    anchors.top: skipCurTargetButton.bottom
    anchors.right: skipCurTargetButton.right
    font.pointSize: 14
  }
}
