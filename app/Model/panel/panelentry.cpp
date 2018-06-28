#include "panelentry.h"


PanelEntry::PanelEntry(QObject* parent): RegovarResource(parent)
{
}
PanelEntry::PanelEntry(QJsonObject json, QObject* parent): PanelEntry(parent)
{
    loadJson(json);
}


bool PanelEntry::loadJson(const QJsonObject& json, bool)
{
    if (json["type"] == "gene")
    {
        mLabel = json["symbol"].toString();
        mDetails = json["details"].toString();
        mType = "gene";
    }
    else
    {

        QString area = QString("Chr%1:%2-%3").arg(json["chr"].toString()).arg(json["start"].toString()).arg(json["end"].toString());
        QString label = json["label"].toString();
        mLabel = label.isEmpty() ? area : label;
        mDetails = label.isEmpty() ? "" : area;
        mType = json["type"].toString();
    }
    mData = json;
    mSearchField = mLabel + " " + mDetails;
    return true;
}


QJsonObject PanelEntry::toJson()
{
    return mData;
}
