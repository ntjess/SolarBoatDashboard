#ifndef DATABASEMARKER_H
#define DATABASEMARKER_H
#include <QSqlQuery>
#include <QString>
#include <string>
#include <QVariant>
#include <QObject>


class DatabaseMarker : public QObject {
	Q_OBJECT
public:
	// It seems to make the most sense to create/delete markers as paths. At
	// the moment, there is no reason to deal with individual markers. This may
	// change if/when markers can be reordered or something

	// Functions for interacting with the database
	// List of markers is already available to the C++ side
	Q_INVOKABLE bool createPathMarkers(QVariantList path_id, QVariantList lat,
			QVariantList lon, QVariantList marker_num);
	Q_INVOKABLE QVariant readPathMarkers(int path_id);
	Q_INVOKABLE bool deletePathMarkers(int path_id);

	// Under the current paradigm, it makes the most sense to just delete the
	// old marker path and create a new one rather than updating it. Otherwise,
	// it would require walking through each marker and seeing what changed.

private:
	const QString TABLE = "markers";
	const QString createMarkerStr = "INSERT INTO " + DatabaseMarker::TABLE
		+ " (path_id, lat, lon, marker_num) VALUES "
		"(?, ?, ?, ?)";
	// There shouldn't be a reason to just grab one marker
	const QString readPathMarkersStr = "SELECT * FROM " + DatabaseMarker::TABLE
			+ " WHERE path_id = :path_id";
	const QString updateMarkerStr = "UPDATE " + DatabaseMarker::TABLE
			+ " set lat = :lat, lon = :lon, marker_num = :marker_num";
	const QString deleteMarkerStr = "DELETE FROM " + DatabaseMarker::TABLE
			+ " WHERE id = (:id)";

};
#endif // DATABASEMARKER_H
