#include "panelversion.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"



PanelVersion::PanelVersion(Panel* rootPanel): RegovarResource(rootPanel)
{
    mEntries = new PanelEntriesListModel(this);
    mPanel = rootPanel;

    connect(mEntries, &PanelEntriesListModel::countChanged, this, &PanelVersion::emitEntriesChanged);
    connect(this, &PanelVersion::dataChanged, this, &PanelVersion::updateSearchField);
}
PanelVersion::PanelVersion(Panel* rootPanel, QJsonObject json): PanelVersion(rootPanel)
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

void PanelVersion::emitEntriesChanged()
{
    emit entriesChanged();
}



//! Set model with provided json data
bool PanelVersion::loadJson(QJsonObject json, bool)
{
    // Load version information
    mId = json["id"].toString();

    mName= json.contains("version") ? json["version"].toString() : json["name"].toString();
    mComment = json["comment"].toString();
    mCreateDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);

    // Load entries
    mEntries->clear();
    for(const QJsonValue& entry: json["entries"].toArray())
    {
        mEntries->append(new PanelEntry(entry.toObject()));
    }
    emit entriesChanged();
    emit dataChanged();
    return true;
}
//! Export model data into json object
QJsonObject PanelVersion::toJson()
{
    QJsonObject result;
    result.insert("id", mId);
    result.insert("name", mName);
    result.insert("comment", mComment);

    return result;
}
//! Save subject information onto server
void PanelVersion::save()
{
    if (mId.isEmpty()) return;
    Request* request = Request::put(QString("/panel/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Panel version saved";
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        request->deleteLater();
    });
}
//! Load Subject information from server
void PanelVersion::load(bool)
{
    // TODO ?
}

// Methods
//! Add a new entry to the list (only used by the qml wizard)
void PanelVersion::addEntry(QJsonObject data)
{
    mEntries->append(new PanelEntry(data));
    emit entriesChanged();
}
//! Reset data (only used by Creation wizard to reset its model)
void PanelVersion::reset(Panel* panel)
{
    // reset all (case of new panel creation)
    mName = "v1";
    mComment = "";
    mEntries->clear();
    // init with provided panel version information (case of new panel version creation)
    if (panel != nullptr && panel->headVersion() != nullptr)
    {
        PanelVersion* head = panel->headVersion();
        // Init new version with information of the head panel
        mName = QString("v%1").arg(panel->versions()->rowCount() + 1);
        mComment = head->comment();
        for (int idx=0; idx < head->entries()->rowCount(); idx++)
        {
            mEntries->append(head->entries()->getAt(idx));
        }
    }

}
