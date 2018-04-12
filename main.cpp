#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

//Local includes
#include "include/CANInterface.h"
#include "include/DBConnection.h"
#include "include/DBMarker.h"
#include "include/DBPath.h"
#include "include/qml_include/RaceTypeClass.h"
#include "include/CANDisplay.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

//		CANInterface *can = new CANInterface();

    DBPath * dbMarkerPath = new DBPath;
    DBMarker *dbMarker = new DBMarker;

//    CANDisplay *canDisplay = new CANDisplay;
    // Allow QML to access necessary C++ classes
    engine.rootContext()->setContextProperty("DBPath", dbMarkerPath);
    engine.rootContext()->setContextProperty("DBMarker", dbMarker);

    // Allow QML to access class that interfaces with CAN data
//    engine.rootContext()->setContextProperty("CANDisplay", canDisplay);

    // Create a database connection
    DBConnection *dbcon = new DBConnection();
    dbcon->initConnection();

    // Allow race type enum in qml
    RaceTypeClass::init();

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

//    can->startListening();

    return app.exec();
}
