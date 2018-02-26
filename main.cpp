#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

//Local includes
#include "include/CANInterface.h"
#include "include/DatabaseConnection.h"
#include "include/DatabaseMarker.h"
#include "include/DatabaseMarkerPath.h"

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

		DatabaseMarkerPath * dbMarkerPath = new DatabaseMarkerPath;

		// Allow QML to access necessary C++ classes
		engine.rootContext()->setContextProperty("DatabaseMarkerPath", dbMarkerPath);
		// Create a database connection
		DatabaseConnection *dbcon = new DatabaseConnection();
		dbcon->initConnection();


		engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
