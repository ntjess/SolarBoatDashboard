#include <QTextCodec>
#include <QDebug>
#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QDateTime>
#include <QVector>
#include <QString>
#include <QUrl>
#include <QLatin1String>
#include <QTextStream>
#include <QDebug>
#include <QStringList>
#include <cmath>
#include <functional>
#include "canBus.h"
#include "canSocket.h"

#ifndef CANINTERFACE_H
#define CANINTERFACE_H

class CANInterface : public QObject
{
    Q_OBJECT
public:
		explicit CANInterface();
    ~CANInterface();
    bool startListening(); //Start listening to the activity on the CAN bus.
    void stopListening();  //Stop listening to the CAN bus.
    bool writeCANFrame(int ID, QByteArray payload);

private Q_SLOTS:

    void readFrame(can_frame frame);

private:
    CanBusModule canBus;
    bool slcandActive;
    bool activateSlcand();
    bool disableSlcand();

    typedef struct {        // Struct to store simulation data from csv file
        QString typeID;
        int canID;
        int min;
        int max;
        QString wForm;
    } simuData;

    QVector<simuData> simulationDataVector;
};

#endif // CANINTERFACE_H
