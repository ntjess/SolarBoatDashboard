#ifndef DATABASECONNECTION_H
#define DATABASECONNECTION_H
#include <QSqlDatabase>

class DatabaseConnection {
public:
	DatabaseConnection(const QString &path);

	void initConnection();
	void closeConnection();

	bool isConnected();

	// Database functions
	void createItem();
	void readItem();
	void updateItem();
	void deleteItem();

private:
		QSqlDatabase database;

};

#endif // DATABASECONNECTION_H
