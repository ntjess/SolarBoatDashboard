#pragma once
#include <QObject>

#include "include/can/canBus.h"
#include "include/can/CANInterface.h"
#include "include/can/canSocket.h"


class CANDisplay : public QObject {
Q_OBJECT

public:
    CANDisplay();
    // Have a property for every displayed CAN bus property
    //Q_PROPERTY(type name READ name WRITE setName NOTIFY nameChanged)

    // Getters and setters variables

private:
    // Variable attached to Q_PROPERTY

signals:
    // void signalNameNotify();
};
