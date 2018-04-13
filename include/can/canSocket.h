#pragma once

/*C++ includes*/
#include <string>
#include <cstring>
#include <iostream>
#include <functional>
#include <iomanip>
#include <map>
#include <thread>
#include <vector>

/*QT Includes*/
#include <QtGlobal>

#if defined(Q_OS_LINUX) || defined(Q_OS_ANDROID)
/*Linux includes*/
#include <linux/can.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#endif

#if defined(Q_OS_WIN)
// Windows doens't know how to handle can frames
struct can_frame {
    uint32_t can_id;  /* 32 bit CAN_ID + EFF/RTR/ERR flags */
    uint8_t    can_dlc; /* frame payload length in byte (0 .. CAN_MAX_DLEN) */
    uint8_t    __pad;   /* padding */
    uint8_t    __res0;  /* reserved / padding */
    uint8_t    __res1;  /* reserved / padding */
    uint8_t    data[8];
};
#endif


struct canThread
{
    volatile bool stop;
    int socketHandle;
    bool socketOpen;
    std::string busName;
    std::thread *actualThread;
};

class CANSocket
{
    public:
        static int Init(std::string connectionName);
        static void Run(int threadNumber);
        static void Stop(int threadNumber);

        static bool isOpen(int threadNumber);
        static bool sendFrame(can_frame frame, int threadNumber);

        static std::map<std::string, std::function<void(can_frame)>> callbacks;
        static std::vector<struct canThread*> activeThreads;
    protected:

    private:
        static int socketHandle;
};
