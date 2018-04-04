import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Item {
    property bool canIncTarget: true
    function updateTexts(done, nextGuideDist, remainingDist, speed) {
        setNextMarker(done, nextGuideDist)
        setDistanceRemaining(done, remainingDist)
        setVelocity(done, speed)
    }

    function setNextMarker(done, dist) {
        if (!done) {
            if (dist >= 0) {
                info.guideTxt = "Distance to next marker: " + dist
            } else {
                info.guideTxt = "No guide marker in place"
            }
        } else {
            info.guideTxt = "DONE!"
        }
    }

    function setDistanceRemaining(done, dist) {
         info.remainingDistTxt = done ? "DONE!" : "Total remaining distance: "
                                         + dist + " m"
    }

    function setVelocity(done, speed) {
        info.velocityTxt = done ? "DONE!" : "Velocity: " + speed + " m/s"
    }

    function incCurTarget() {
        if (canIncTarget) {
            map.curTarget = (map.curTarget + 1) % map.numMarkers
        }
    }

}
