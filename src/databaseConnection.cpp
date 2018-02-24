#include "include/databaseConnection.h"

DatabaseConnection::DatabaseConnection(const QString &path) {
	database = QSqlDatabase::addDatabase("QSQLITE");
	database.setDatabaseName(path);

	if (!database.open()) {
		qDebug() << "Cannot connect to database " + path;
	} else {
		qDebug() << "Successful conenction to " + path;
	}
}
