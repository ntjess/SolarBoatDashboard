#include "include/DatabaseMarker.h"
#include <QDebug>
#include <QSqlError>
#include <QVariantList>

bool DatabaseMarker::createPathMarkers(QVariantList path_id, QVariantList lat,
												QVariantList lon, QVariantList marker_num) {
	bool success = false;
	QSqlQuery q;
	q.prepare(createMarkerStr);
	qDebug() << "valid: " << q.isValid();
	qDebug() << " : " << q.lastError().text();
	q.addBindValue(path_id);
	q.addBindValue(lat);
	q.addBindValue(lon);
	q.addBindValue(marker_num);
	if (q.execBatch()) {
		success = true;
	} else {
		qDebug() << "createMarker error: " << q.lastError().text();
		success = false;
	}

	return success;
}

QVariantList DatabaseMarker::readPathMarkers(int path_id) {
	QVariantList markers, markerData;
	QSqlQuery q;
	q.prepare(readPathMarkersStr);
	q.addBindValue(path_id);
	if (q.exec()) {
		while (q.next()) {
			markerData << q.value(2).toDouble();
			markerData << q.value(3).toDouble();
			markerData << q.value(4).toInt();
			markers << QVariant(markerData);
			markerData.clear();
		}
	} else {
		qDebug() << "readPathMarkers error: " << q.lastError().text();
		return QVariantList();
	}
	return markers;
}

bool DatabaseMarker::deletePathMarkers(int path_id) {
	bool success = false;
	QSqlQuery q;
	q.prepare(deleteMarkerPathStr);
	q.addBindValue(path_id);

	if (q.exec()) {
		success = true;
	} else {
		qDebug() << "DeleteMarker error: " << q.lastError().text();
	}

	return success;
}
