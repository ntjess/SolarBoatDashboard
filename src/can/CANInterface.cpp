#include <QFile>

#include "include/can/CANInterface.h"
CANInterface::CANInterface()
{
    slcandActive = false;
    canBus.registerCallback("GetFrame", std::bind(&CANInterface::readFrame, this, std::placeholders::_1));
}

CANInterface::~CANInterface()
{
    stopListening();
}

bool CANInterface::startListening()
{
    bool slcandSuccess = false;

#ifdef Q_OS_ANDROID
        slcandSuccess = activateSlcand();
#elif defined(Q_OS_LINUX)
        slcandSuccess = true;
#elseF
        slcandSuccess = false;
#endif
        if (slcandSuccess) {
            canBus.StartupModule();
            slcandActive = true;
        }
    // TODO: change to something that doesn't always return false when not
    // simulating
		return slcandSuccess;
}

void CANInterface::stopListening()
{
	canBus.ShutdownModule();
	slcandActive = false;
	disableSlcand();
}

bool CANInterface::writeCANFrame(int ID, QByteArray payload)
{
//    int d[payload.size()];

//    for(int i = 0; i < payload.size(); i++) {
//        d[i] = payload[i];
//    }

//    canBus.sendFrame(ID, d,payload.size());
	return false;
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
