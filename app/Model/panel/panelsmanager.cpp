#include "panelsmanager.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

PanelsManager::PanelsManager(QObject* parent) : QObject(parent)
{
    mNewPanel = new Panel(this);
    mPanelsTree = new PanelsTreeModel();
}



Panel* PanelsManager::getOrCreatePanel(QString id)
{
    // Check if id found in panels
    if (mPanels.contains(id))
    {
        return mPanels[id];
    }
    // Check if id found in panels versions
    for(Panel* panel: mPanels.values())
    {
        if (panel->getVersion(id) != nullptr)
        {
            return panel;
        }
    }
    // else create new panel
    Panel* newPanel = new Panel(true);
    mPanels.insert(id, newPanel);
    return newPanel;
}



void PanelsManager::commitNewPanel()
{
    Request* req = Request::post(QString("/panel"), QJsonDocument(mNewPanel->toJson()).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            Panel* panel = getOrCreatePanel(data["id"].toString());
            panel->fromJson(data);
            updatePanelsLists();
            emit commitNewPanelDone(true);
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
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
            // Refreshing treeModel with provided json will Create/update internal collection of panel
            mPanelsTree->refresh(json);
            // Refresh public model used by QML
            updatePanelsLists();
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build projects tree model (due to request error)";
        }
        mPanelsTree->setIsLoading(false);
        request->deleteLater();
    });
}



void PanelsManager::updatePanelsLists()
{
    mPanelsList.clear();
    for(Panel* panel: mPanels.values())
    {
        mPanelsList.append(panel);
    }


    emit panelsChanged();
}





