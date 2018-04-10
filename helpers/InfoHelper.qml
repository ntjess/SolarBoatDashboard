import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Item {
  property bool canIncTarget: false
  property bool forceInc: false
  function updateTexts(nextGuideDist, remainingDist, speed) {
    setNextMarker(nextGuideDist)
    setDistanceRemaining(remainingDist)
    setVelocity(speed)
  }

  function setNextMarker(dist) {
    info.guideTxt = "Next Guide: "
    info.guideTxt += (dist > 0 ? dist + " m" : "N/A")
  }

  function setDistanceRemaining(dist) {
    info.remainingDistTxt = "Distance remaining: " + dist + " m"
  }

  function setVelocity(speed) {
    // Round to two decimal places
    info.velocityTxt = "Velocity: " + Math.round(speed * 100) / 100 + " m/s"
  }
}
