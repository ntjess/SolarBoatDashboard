#include "include/DatabaseMarker.h"
#include <QDebug>
#include <QSqlError>
#include <QVariantList>

bool DatabaseMarker::createPathMarkers(QVariantList path_id, QVariantList lat,
												QVariantList lon, QVariantList marker_num) {
	bool success = false;
	QSqlQuery query;
	query.prepare(createMarkerStr);
	qDebug() << "valid: " << query.isValid();
	qDebug() << " : " << query.lastError().text();
	query.addBindValue(path_id);
	query.addBindValue(lat);
	query.addBindValue(lon);
	query.addBindValue(marker_num);
	if (query.execBatch()) {
		success = true;
	} else {
		qDebug() << "createMarker error: " << query.lastError().text();
		success = false;
	}

	return success;
}

QVariant DatabaseMarker::readPathMarkers(int path_id) {
	QVariant markers;
	QSqlQuery query;
	query.prepare(createMarkerStr);
	query.addBindValue(path_id);
	if (query.exec()) {
	} else {
		qDebug() << "readPathMarkers error: " << query.lastError().text();
	}
	return markers;
}

bool DatabaseMarker::deletePathMarkers(int path_id) {
	bool success = false;
	QSqlQuery query;
	query.prepare(deleteMarkerStr);
	query.addBindValue(path_id);

	if (query.exec()) {
		success = true;
	} else {
		qDebug() << "DeleteMarker error: " << query.lastError().text();
	}

	return success;
}
