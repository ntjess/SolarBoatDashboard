#ifndef DBConnection_H
#define DBConnection_H
#include <QSqlDatabase>
#include <QtDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlDriver>
#include <Qdir>

#include "DBMarker.h"

class DBConnection {
public:
	DBConnection();

	void initConnection();// ":/res/database/paths.db");
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

#endif // DBConnection_H
