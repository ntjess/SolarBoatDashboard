#include "include/DBConnection.h"


DBConnection::DBConnection() {
}

void DBConnection::initConnection() {
	QString dbFile = QDir::currentPath() + "/res/database/solar_boat.db";
	// Android doesn't allow file modification unless it is a local file
	if(!QFile::exists(dbFile)) {
		QFile::copy(QString(":/res/database/solar_boat.db"), dbFile);
		QFile::setPermissions(dbFile,
		QFile::ReadOwner|QFile::WriteOwner);
	}
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
