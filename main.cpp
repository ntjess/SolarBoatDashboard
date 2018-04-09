#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

//Local includes
#include "include/CANInterface.h"
#include "include/DBConnection.h"
#include "include/DBMarker.h"
#include "include/DBPath.h"
#include "include/qml_include/RaceTypeClass.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

		DBPath * dbMarkerPath = new DBPath;
		DBMarker *dbMarker = new DBMarker;

		// Allow QML to access necessary C++ classes
		engine.rootContext()->setContextProperty("DBPath", dbMarkerPath);
		engine.rootContext()->setContextProperty("DBMarker", dbMarker);
		// Create a database connection
		DBConnection *dbcon = new DBConnection();
		dbcon->initConnection();

        // Allow race type enum in qml
        RaceTypeClass::init();

		engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
