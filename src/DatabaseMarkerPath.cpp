#include <QDebug>
#include <QSqlError>

#include "include/DatabaseMarkerPath.h"
#include "include/DatabaseMarker.h"

int DatabaseMarkerPath::createPath(QString pathName, QVariantList lat, QVariantList lon,
																	 QVariantList marker_num) {
	int pathId = -1;
	QSqlQuery query;
	query.prepare(createPathStr);
	query.addBindValue(pathName);

	if (query.exec()) {
		pathId = query.lastInsertId().toInt();
		DatabaseMarker m;
		// Each specified marker needs the same path. Create an array of them.
		QVariantList pathIds;
		for (int i = 0; i < marker_num.length(); i++) {
			pathIds << pathId;
		}
		m.createPathMarkers(pathIds, lat, lon, marker_num);
		return pathId;
	} else {
		// Indicate creation was unsuccessful
		qDebug() << "Could not create path: " << query.lastError().text();
		return -1;
	}


}

bool DatabaseMarkerPath::readPath(int id) {
return false;
}

bool DatabaseMarkerPath::updatePath(int id) {
return false;
}

bool DatabaseMarkerPath::deletePath(int id) {
return false;
}
