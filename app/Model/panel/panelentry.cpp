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
        mDetails = "";
        mType = "gene";
    }
    else
    {
        mLabel = "";
        mDetails = QString("Chr%1:%2-%3").arg(json["chr"].toInt()).arg(json["start"].toInt()).arg(json["end"].toInt());
        mType = "region";
    }
}


QJsonObject PanelEntry::toJson()
{
    QJsonObject result;

    result.insert("type", mType);
    result.insert("details", mDetails);
    result.insert("label", mLabel);

    return result;
}
