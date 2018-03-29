#ifndef DBPath_H
#define DBPath_H
#include <QSqlQuery>
#include <QString>
#include <string>
#include <QVariant>
#include <QObject>


class DBPath : public QObject {
	Q_OBJECT
public:
//	explicit DBPath(QObject* parent = nullptr) : QObject(parent) {}

	// Returns id of created path
	Q_INVOKABLE int createPath(QString pathName, QVariantList lat, QVariantList lon,
														 QVariantList is_guide, QVariantList marker_num);
	Q_INVOKABLE bool readPath(int id);
	Q_INVOKABLE bool updatePath(int id);
	Q_INVOKABLE bool deletePath(int id);

	// Used on QML side for generating menu of paths
	Q_INVOKABLE QVariantList readAllPaths();

private:
	// SQL strings to create database objects
	const QString TABLE = "marker_paths";
	const QString createPathStr = "INSERT INTO " + DBPath::TABLE
		+ " (name) VALUES (?)";
	const QString readPathsStr = "SELECT * FROM" + DBPath::TABLE
			+ " WHERE path_id = :path_id";
	const QString updatePathStr = "UPDATE" + DBPath::TABLE
			+ " SET lat = :lat, lon = :lon, is_guide = :is_guide, marker_num = :marker_num";
	const QString deletePathStr = "DELETE FROM " + DBPath::TABLE
			+ " WHERE id = (:id)";
	const QString readAllPathsStr = "SELECT * FROM " + DBPath::TABLE;
};

#endif // DBPath_H
