#ifndef DATABASECONNECTION_H
#define DATABASECONNECTION_H
#include <QSqlDatabase>
#include <QtDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlDriver>

#include "DatabaseMarker.h"

class DatabaseConnection {
public:
	DatabaseConnection();

	void initConnection(const QString &path = "C:/Users/Nathan/Desktop/UpdatedSolarBoat/SolarBoatDashboard/res/database/paths.db");// ":/res/database/paths.db");
	void closeConnection();
	void test() {
		QSqlQuery q = database.exec("SELECT * FROM markers");
		if(!q.lastError().isValid())
		{
				qDebug()<<"works!";
		}
		else
		{
				 qDebug()<<"---db failed to open! , error: "<<q.lastError().text();
		}
		database.close();
	}

	bool isConnected();

private:
	QSqlDatabase database;


};

#endif // DATABASECONNECTION_H
