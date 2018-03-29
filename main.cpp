#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

//Local includes
#include "include/CANInterface.h"
#include "include/DBConnection.h"
#include "include/DBMarker.h"
#include "include/DBPath.h"

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

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


		engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
