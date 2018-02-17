#ifndef DATAPROCESSOR_H
#define DATAPROCESSOR_H

#include "include/canSocket.h"

class DataProcessor
{
public:
    DataProcessor();

    void routeCANFrame(can_frame frame);


};

#endif // DATAPROCESSOR_H
