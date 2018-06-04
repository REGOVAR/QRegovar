#include "panelsmanager.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

PanelsManager::PanelsManager(QObject* parent) : QObject(parent)
{
    mNewPanel = new Panel(this);
    mNewPanel->versions()->addVersion(new PanelVersion(mNewPanel));
    mPanelsTree = new PanelsTreeModel(this);
    mPanelsList = new PanelsListModel(this);

    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(mPanelsTree);
    mProxy->setFilterRole(PanelsTreeModel::Roles::SearchField);
    mProxy->setSortRole(PanelsTreeModel::Roles::Name);
    mProxy->setRecursiveFilteringEnabled(true);
}



Panel* PanelsManager::getOrCreatePanel(QString id)
{
    // id may be panel id or panel version id
    //   if panel id: return the panel
    //   if version id: return panel that own this version

    // Check if id found in panels
    if (mPanels.contains(id))
    {
        return mPanels[id];
    }
    // Check if id found in panels versions
    for(Panel* panel: mPanels.values())
    {
        if (panel->versions()->getVersion(id) != nullptr)
        {
            return panel;
        }
    }
    // else create new empty panel
    Panel* newPanel = new Panel(this);
    mPanels.insert(id, newPanel);
    mPanelsList->append(newPanel->headVersion());
    return newPanel;
}

PanelVersion* PanelsManager::getPanelVersion(QString id)
{
    // id may be panel id or panel version id
    //   if panel id: return the head version of this panel
    //   if version id: return the version

    // Check if id found in panels
    if (mPanels.contains(id))
    {
        return mPanels[id]->headVersion();
    }
    // Check if id found in panels versions
    for(Panel* panel: mPanels.values())
    {
        PanelVersion* version = panel->versions()->getVersion(id);
        if (version != nullptr)
        {
            return version;
        }
    }
    return nullptr;
}


void PanelsManager::commitNewPanel()
{
    PanelVersion* head = mNewPanel->headVersion();
    QJsonObject result;
    result.insert("id", mNewPanel->id());
    result.insert("version_id", head->id());
    result.insert("name", mNewPanel->name());
    result.insert("version", head->name());
    result.insert("owner", mNewPanel->owner());
    result.insert("description", mNewPanel->description());
    result.insert("shared", mNewPanel->shared());

    if (head->entries()->rowCount() > 0)
    {
        QJsonArray entries;
        for(int idx=0; idx < head->entries()->rowCount(); idx++)
        {
            entries.append(head->entries()->getAt(idx)->toJson());
        }
        result.insert("entries", entries);
    }

    Request* req = Request::post(QString("/panel"), QJsonDocument(result).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            refresh();
            emit commitNewPanelDone(true);
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
            emit commitNewPanelDone(false);
        }
        req->deleteLater();
    });
}



void PanelsManager::searchPanelEntry(QString query)
{
    Request* request = Request::get(QString("/panel/search/%1").arg(query));
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            emit searchPanelEntryDone(data);
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Error occured when search panel entries";
        }
        request->deleteLater();
    });
}



void PanelsManager::refresh()
{
    mPanelsTree->setIsLoading(true);

    Request* request = Request::get("/panel");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            loadJson(json["data"].toArray());
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build projects tree model (due to request error)";
        }
        mPanelsTree->setIsLoading(false);
        request->deleteLater();
    });
}
bool PanelsManager::loadJson(QJsonArray data)
{
    // Refreshing treeModel with provided json will Create/update internal collection of panel
    mPanelsTree->refresh(data);
    // Update list of panel
    mPanelsList->clear();
    for(Panel* panel: mPanels.values())
    {
        mPanelsList->append(panel->headVersion());
    }
    emit panelsChanged();
    return true;
}





