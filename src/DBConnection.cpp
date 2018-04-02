#include "include/DBConnection.h"


DBConnection::DBConnection() {
}

void DBConnection::initConnection() {
    QDir dir("res/database/");
    QString dbFile = dir.absoluteFilePath("solar_boat.db");
    database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName(dbFile);
	if (!database.open()) {
		qDebug() << "Error: " << database.lastError().text();
	} else {
        qDebug() << "Successful conenction to " << dbFile << endl;
	}
}

void DBConnection::closeConnection() {
	database.close();
}

bool DBConnection::isConnected() {
	return database.isOpen();
}
