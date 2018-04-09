#include "../include/CANInterface.h"
#include <QFile>
CANInterface::CANInterface(bool simulateInput)
{
    this->simulateInput = simulateInput;
    slcandActive = false;

    if(simulateInput)
    {
        QFile simuDataFile(":/simulationData.csv");

        if (!simuDataFile.open(QIODevice::ReadOnly | QIODevice::Text)) {

            qDebug() << simuDataFile.errorString();
            return;
        }

        QTextStream in(&simuDataFile);
        while (!in.atEnd()) {
            simuData temp;
            QString line = in.readLine();
            QStringList sLine = line.split(',');

            temp.typeID = sLine[0];
            temp.canID = sLine[1].toInt();
            temp.min = sLine[2].toInt();
            temp.max = sLine[3].toInt();
            temp.wForm = sLine[4];

            simulationDataVector.append(temp);
        }

        simulationTimer = new QTimer();
        connect(simulationTimer, SIGNAL(timeout()), this, SLOT(simulateInputFrames()));
    }

    canBus.registerCallback("GetFrame", std::bind(&CANInterface::readFrame, this, std::placeholders::_1));
}

CANInterface::~CANInterface()
{
    stopListening();
    delete simulationTimer;
}

bool CANInterface::startListening()
{
    bool slcandSuccess = false;
    bool success = false;
    if(simulateInput)
    {
        simulationTimer->start(500);//Set the sampling reate to be half a second. In ms.
        success = true;
    }
    else
    {
#ifdef Q_OS_ANDROID
        slcandSuccess = activateSlcand();
#elif defined(Q_OS_LINUX)
        slcandSuccess = true;
#else
        slcandSuccess = false;
#endif
        if (slcandSuccess) {
            canBus.StartupModule();
            slcandActive = true;
        }
    }
    // TODO: change to something that doesn't always return false when not
    // simulating
    return success;
}

void CANInterface::stopListening()
{
    if(simulateInput)
    {
        simulationTimer->stop();
    }
    else
    {
        canBus.ShutdownModule();
        slcandActive = false;
        disableSlcand();
    }
}

bool CANInterface::writeCANFrame(int ID, QByteArray payload)
{
    int d[payload.size()];

    for(int i = 0; i < payload.size(); i++) {
        d[i] = payload[i];
    }

    canBus.sendFrame(ID, d,payload.size());
}

void CANInterface::simulateInputFrames()
{
    QVectorIterator<simuData> simIter(simulationDataVector);
    while(simIter.hasNext())
    {
        simuData currentData = simIter.next();
        can_frame simulatedFrame;
        simulatedFrame.can_id = currentData.canID;

        //Now we should simulate the byte data based on simulation type
        if(currentData.wForm == "sin") {
            double d = sin(QDateTime::currentSecsSinceEpoch() % currentData.max);
            simulatedFrame.data[0] = (int) d;
//            dataProcessor->routeCANFrame(simulatedFrame);
        }
        else if(currentData.wForm == "random")
        {
            qsrand(QDateTime::currentMSecsSinceEpoch());
            double d = qrand() % 11;
            simulatedFrame.data[0] = (int) d;
//            dataProcessor->routeCANFrame(simulatedFrame);
        }
    }
}

void CANInterface::readFrame(can_frame frame)
  //can_frame is defined in the Android SDK. Contains 32 bit can ID
{
    //dataProcessor->routeCANFrame(frame);
}

bool CANInterface::activateSlcand()
{
    // Essentially, this code invokes safety features to ensure only one copy of
    // can interfaces are present within the system. Thus, if activateSlcand is
    // called twice for some reason, it can properly clean up after itself.

    // Invokes OS process
    QProcess ifconfigStop;
    //We have to pass the parameters as a list otherwise they get globbed together and fail to do anything.
    // Linux network utility for interface management
    // As su, run ifconfig setting the can0 interface down. Make sure there is no
    // can0 interface that could screw up code
    ifconfigStop.start("su", QStringList() << "-c" << "ifconfig" << "can0" << "down");
    // Wait for process to properly start and finish before continuing
    ifconfigStop.waitForStarted();
    ifconfigStop.waitForFinished();

    // Kill any potential slcand processes.
    CANInterface::disableSlcand();

    if(!slcandActive)
    {
        //Try to allow CAN bus to talk on the bus by first activating slcand and disabling the SELinux port restrictions
        QProcess slcand;
        slcand.start("su", QStringList() << "");
        slcand.waitForStarted();

        // slcand -speed 500k, -USB speed max, -open, -close flags, path to desired USB hardware
        // specify interface we want to create
        slcand.write("slcand -s 6 -S 3000000 -o -c /dev/ttyACM* can0");
        slcand.closeWriteChannel();

        slcand.waitForFinished();

        QProcess ifconfig;
        ifconfig.start("su", QStringList() << "-c" << "ifconfig" << "can0" << "up");
        ifconfig.waitForStarted();
        ifconfig.waitForFinished();

        QProcess selinux;
        // stop enforcing network protocol. This makes our device EXTREMELY insecure
        selinux.start("su", QStringList() << "-c" << "setenforce 0");
        selinux.waitForStarted();
        selinux.waitForFinished();

        slcandActive = true;
    }
    return slcandActive;
}

bool CANInterface::disableSlcand()
{
    bool success = false;
    if(slcandActive)
    {
        QProcess pkill;
        pkill.start("su", QStringList() << "-c" << "pkill" << "slcand");
        pkill.waitForFinished();
        slcandActive = false;
        success = true;
    }
    return success;
}
