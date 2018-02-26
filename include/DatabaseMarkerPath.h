#ifndef DatabaseMarkerPath_H
#define DatabaseMarkerPath_H
#include <QSqlQuery>
#include <QString>
#include <string>
#include <QVariant>
#include <QObject>


class DatabaseMarkerPath : public QObject {
	Q_OBJECT
public:
//	explicit DatabaseMarkerPath(QObject* parent = nullptr) : QObject(parent) {}

	// Returns id of created path
	Q_INVOKABLE int createPath(QString pathName, QVariantList lat, QVariantList lon,
														 QVariantList marker_num);
	Q_INVOKABLE bool readPath(int id);
	Q_INVOKABLE bool updatePath(int id);
	Q_INVOKABLE bool deletePath(int id);

private:
	// SQL strings to create database objects
	const QString TABLE = "marker_paths";
	const QString createPathStr = "INSERT INTO " + DatabaseMarkerPath::TABLE
		+ " (name) VALUES (?)";
	const QString readMarkerPathsStr = "SELECT * FROM" + DatabaseMarkerPath::TABLE
			+ " WHERE path_id = :path_id";
	const QString updateMarkerPathStr = "UPDATE" + DatabaseMarkerPath::TABLE
			+ " SET lat = :lat, lon = :lon, marker_num = :marker_num";
	const QString deleteMarkerPathStr = "DELETE FROM " + DatabaseMarkerPath::TABLE
			+ " WHERE id = (:id)";
};

#endif // DatabaseMarkerPath_H
