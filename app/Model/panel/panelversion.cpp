#include "panelversion.h"

PanelVersion::PanelVersion(QObject* parent) : QObject(parent)
{
}
PanelVersion::PanelVersion(QJsonObject json, QObject* parent) : QObject(parent)
{
    mId = json["id"].toString();
    mVersion = json["version"].toString();
    mComment = json["comment"].toString();
    mCreationDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);

    mEntries.clear();
    for(QJsonValue v: json["entries"].toArray())
    {
        mEntries.append(v.toVariant());
    }
}
