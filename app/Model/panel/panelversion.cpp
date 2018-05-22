#include "panelversion.h"


PanelVersion::PanelVersion(QObject* parent): RegovarResource(parent)
{

}
PanelVersion::PanelVersion(Panel* rootPanel, QObject* parent): PanelVersion(parent)
{
    mPanel = rootPanel;
}



QString PanelVersion::fullname() const
{
    return QString("%1 (%2)").arg(mPanel->name(), mName);
}

//! Set model with provided json data
bool PanelVersion::loadJson(QJsonObject json)
{
    // Load version information
    mVersionId = json["id"].toString();
    mVersion = json["name"].toString();
    mComment = json["comment"].toString();
    mCreateDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);

    // Load entries
    for(const QJsonValue& entry: json["entries"].toArray())
    {
        // Compute details field
        QJsonObject entryData = entry.toObject();

        if (entryData.contains("symbol"))
        {
            entryData.insert("details", "");
        }
        else
        {
            entryData.insert("details", QString("Chr%1:%2-%3").arg(entryData["chr"].toInt()).arg(entryData["start"].toInt()).arg(entryData["end"].toInt()));
        }
        mEntries.append(entryData);
    }
}
//! Export model data into json object
QJsonObject PanelVersion::toJson()
{

}
//! Save subject information onto server
void PanelVersion::save()
{

}
//! Load Subject information from server
void PanelVersion::load(bool forceRefresh)
{

}

// Methods
//! Add a new entry to the list (only used by the qml wizard)
void PanelVersion::addEntry(QJsonObject data)
{

}
//! Reset data (only used by Creation wizard to reset its model)
void PanelVersion::reset()
{

}
