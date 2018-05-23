#include "panelentry.h"


PanelEntry::PanelEntry(QObject* parent): RegovarResource(parent)
{
}
PanelEntry::PanelEntry(QJsonObject json, QObject* parent): PanelEntry(parent)
{
    loadJson(json);
}


bool PanelEntry::loadJson(QJsonObject json)
{
    if (json["type"] == "gene")
    {
        mLabel = json["symbol"].toString();
        mDetails = json["details"].toString();
        mType = "gene";
    }
    else
    {
        mLabel = json["label"].toString();
        mDetails = QString("Chr%1:%2-%3").arg(json["chr"].toInt()).arg(json["start"].toInt()).arg(json["end"].toInt());
        mType = "region";
    }
    mData = json;
    mSearchField = mLabel + " " + mDetails;
}


QJsonObject PanelEntry::toJson()
{
    return mData;
}
