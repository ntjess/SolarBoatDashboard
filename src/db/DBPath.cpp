#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>

#include "include/db/DBPath.h"
#include "include/db/DBMarker.h"

int DBPath::createPath(QString pathName, QVariantList lat, QVariantList lon,
																	 QVariantList is_guide, QVariantList marker_num) {
	int pathId = -1;
	QSqlQuery q;
	q.prepare(createPathStr);
	q.addBindValue(pathName);

	if (q.exec()) {
		pathId = q.lastInsertId().toInt();
		DBMarker m;
		// Each specified marker needs the same path. Create an array of them.
		QVariantList pathIds;
		for (int i = 0; i < marker_num.length(); i++) {
			pathIds << pathId;
		}
		m.createPathMarkers(pathIds, lat, lon, is_guide, marker_num);
		return pathId;
	} else {
		// Indicate creation was unsuccessful
		qDebug() << "Could not create path: " << q.lastError().text();
		return -1;
	}
}

bool DBPath::readPath(int id) {
return false;
}

bool DBPath::updatePath(int id) {
return false;
}

bool DBPath::deletePath(int id) {
	DBMarker m;
	// First, try to delete the markers associated with the path
	bool success = m.deletePathMarkers(id);
	// Only delete the path from the id list if it was successful
	if (success) {
		QSqlQuery q;
		q.prepare(deletePathStr);
		q.addBindValue(id);
		if (q.exec()) {
			// Path was successfully deleted
			return true;
		} else {
			qDebug() << "Failed to delete marker path: " << q.lastError().text();
			return false;
		}
	} else {
		// Markers didn't delete. Don't delete the path, or else there is
		// no way to identify the markers without iterating through all
		// other paths
		qDebug() << "Markers didn't delete, so path didn't delete" << endl;
		return false;
	}
}

QVariantList DBPath::readAllPaths() {
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

//QVariantList DBPath::test() {
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
