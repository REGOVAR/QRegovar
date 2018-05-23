#include "panelversion.h"


PanelVersion::PanelVersion(QObject* parent): RegovarResource(parent)
{
    mEntries = new PanelEntriesListModel(this);
    connect(this, &PanelVersion::dataChanged, this, &PanelVersion::updateSearchField);
}
PanelVersion::PanelVersion(Panel* rootPanel, QObject* parent): PanelVersion(parent)
{
    mPanel = rootPanel;
}
PanelVersion::PanelVersion(Panel* rootPanel, QJsonObject json,  QObject* parent): PanelVersion(parent)
{
    mPanel = rootPanel;
    loadJson(json);
}


QString PanelVersion::fullname() const
{
    return QString("%1 (%2)").arg(mPanel->name(), mName);
}



void PanelVersion::updateSearchField()
{
    mSearchField = mName + " " + mComment;
    for(int idx=0; idx < mEntries->rowCount(); idx++)
    {
        PanelEntry* entry = mEntries->getAt(idx);
        mSearchField += " " + entry->searchField();
    }
}



//! Set model with provided json data
bool PanelVersion::loadJson(QJsonObject json)
{
    // Load version information
    mId = json["id"].toString();
    mName= json["version"].toString();
    mComment = json["comment"].toString();
    mCreateDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);

    // Load entries
    for(const QJsonValue& entry: json["entries"].toArray())
    {
        mEntries->append(new PanelEntry(entry.toObject()));
    }
    emit entriesChanged();
    emit dataChanged();
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
    mEntries->append(new PanelEntry(data));
    emit entriesChanged();
}
//! Reset data (only used by Creation wizard to reset its model)
void PanelVersion::reset()
{

}
