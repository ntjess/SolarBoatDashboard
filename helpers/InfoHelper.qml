import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Item {
    property bool canIncTarget: false
    property bool forceInc: false
    function updateTexts(done, nextGuideDist, remainingDist, speed) {
        setNextMarker(done, nextGuideDist)
        setDistanceRemaining(done, remainingDist)
        setVelocity(done, speed)
    }

    function setNextMarker(done, dist) {
        if (!done) {
            if (dist >= 0) {
                info.guideTxt = "Next Guide: " + dist
            } else {
                info.guideTxt = "No guide marker in place"
            }
        } else {
            info.guideTxt = "DONE!"
        }
    }

    function setDistanceRemaining(done, dist) {
         info.remainingDistTxt = done ? "DONE!" : "Remaining distance: "
                                         + dist + " m"
    }

    function setVelocity(done, speed) {
        // Round to two decimal places
        info.velocityTxt = done ? "DONE!" : "Velocity: " + Math.round(speed*100)/100 + " m/s"
    }
}
