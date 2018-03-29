#include "include/DBConnection.h"


DBConnection::DBConnection() {
}

void DBConnection::initConnection(const QString &path) {
	database = QSqlDatabase::addDatabase("QSQLITE");
	database.setDatabaseName(path);
	if (!database.open()) {
		qDebug() << "Error: " << database.lastError().text();
	} else {
		qDebug() << "Successful conenction to " << path << endl;
	}
}

void DBConnection::closeConnection() {
	database.close();
}

bool DBConnection::isConnected() {
	return database.isOpen();
}
