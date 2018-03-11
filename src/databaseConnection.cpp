#include "include/databaseConnection.h"


DatabaseConnection::DatabaseConnection() {
}

void DatabaseConnection::initConnection(const QString &path) {
	database = QSqlDatabase::addDatabase("QSQLITE");
	database.setDatabaseName(path);
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
