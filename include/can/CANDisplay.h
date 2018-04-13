#pragma once
#include <QObject>

#include "include/canBus.h"
#include "include/CANInterface.h"
#include "include/canSocket.h"


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
