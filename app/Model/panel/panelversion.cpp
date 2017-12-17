#include "panelversion.h"

PanelVersion::PanelVersion(Panel* panel) : QObject(panel)
{
    mPanel = panel;
}
PanelVersion::PanelVersion(QJsonObject json, Panel* panel) : QObject(panel)
{
    mPanel = panel;
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
