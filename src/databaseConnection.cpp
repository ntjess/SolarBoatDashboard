#include "include/databaseConnection.h"


DatabaseConnection::DatabaseConnection() {
}

void DatabaseConnection::initConnection(const QString &path) {
	database = QSqlDatabase::addDatabase("QSQLITE");
	qDebug() << "addDatabase";
	database.setDatabaseName(path);
	qDebug() << "setDatabaseName";
	if (!database.open()) {
		qDebug() << "Error: " << database.lastError().text();
	} else {
		qDebug() << "Successful conenction to " << path << endl;
	}
}

void DatabaseConnection::closeConnection() {
	database.close();
}

bool DatabaseConnection::isConnected() {
	return database.isOpen();
}
