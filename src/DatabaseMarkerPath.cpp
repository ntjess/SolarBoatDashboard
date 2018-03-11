#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>

#include "include/DatabaseMarkerPath.h"
#include "include/DatabaseMarker.h"

int DatabaseMarkerPath::createPath(QString pathName, QVariantList lat, QVariantList lon,
																	 QVariantList marker_num) {
	int pathId = -1;
	QSqlQuery q;
	q.prepare(createPathStr);
	q.addBindValue(pathName);

	if (q.exec()) {
		pathId = q.lastInsertId().toInt();
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
		qDebug() << "Could not create path: " << q.lastError().text();
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
    // Make sure to delete path and all markers associated with it
}

QVariantList DatabaseMarkerPath::readAllPaths() {
	// Need to put ids and names into one list to return
	QVariantList toReturn, ids, names;

	QSqlQuery q;
	q.prepare(readAllPathsStr);
	if (q.exec()) {
		// Retrieve each pair of values, adding them to a list of what to return
		while (q.next()) {
		// TODO refer to columns with variables, not hard-coded ints
			ids << q.value(0).toInt();
			names << q.value(1).toString();
		}
		// ids, names should now contain all current paths in the db.
	} else {
		qDebug() << "Failed to read paths: " << q.lastError().text();
		ids << -1;
		names << "Failed query";
	}
	toReturn << QVariant(ids) << QVariant(names);
	return toReturn;
}

//QVariantList DatabaseMarkerPath::test() {
//	QSqlQuery q = database.exec("SELECT * FROM marker_paths");
//	if(!q.lastError().isValid())
//	{
//			qDebug()<<"works!";
//	}
//	else
//	{
//			 qDebug()<<"---db failed to select! , error: "<<q.lastError().text();
//	}
//}
