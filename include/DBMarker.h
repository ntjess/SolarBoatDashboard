#ifndef DBMarker_H
#define DBMarker_H
#include <QSqlQuery>
#include <QString>
#include <string>
#include <QVariant>
#include <QObject>


class DBMarker : public QObject {
	Q_OBJECT
public:
	// It seems to make the most sense to create/delete markers as paths. At
	// the moment, there is no reason to deal with individual markers. This may
	// change if/when markers can be reordered or something

	// Functions for interacting with the database
	// List of markers is already available to the C++ side
	Q_INVOKABLE bool createPathMarkers(QVariantList path_id, QVariantList lat,
			QVariantList lon, QVariantList is_guide, QVariantList marker_num);
	Q_INVOKABLE QVariantList readPathMarkers(int path_id);
	Q_INVOKABLE bool deletePathMarkers(int path_id);

	// Under the current paradigm, it makes the most sense to just delete the
	// old marker path and create a new one rather than updating it. Otherwise,
	// it would require walking through each marker and seeing what changed.

private:
	const QString TABLE = "markers";
	const QString createMarkerStr = "INSERT INTO " + DBMarker::TABLE
		+ " (path_id, lat, lon, is_guide, marker_num) VALUES "
		"(?, ?, ?, ?, ?)";
	// There shouldn't be a reason to just grab one marker
	const QString readPathMarkersStr = "SELECT * FROM " + DBMarker::TABLE
			+ " WHERE path_id = :path_id";
	const QString deleteMarkerPathStr = "DELETE FROM " + DBMarker::TABLE
			+ " WHERE path_id = (:path_id)";

};
#endif // DBMarker_H
