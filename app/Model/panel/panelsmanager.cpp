#include "panelsmanager.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

PanelsManager::PanelsManager(QObject* parent) : QObject(parent)
{

}



void PanelsManager::updatePanelsList()
{
    mPanelsList.clear();
    for(Panel* panel: mPanels.values())
    {
        mPanelsList.append(panel);
    }
}


Panel* PanelsManager::getOrCreatePanel(int id)
{
    if (mPanels.contains(id))
    {
        return mPanels[id];
    }
    // else
    Panel* newPanel = new Panel(id);
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
            Panel* panel = getOrCreatePanel(data["id"].toInt());
            panel->fromJson(data);
            updatePanelsList();
            emit commitNewPanelDone(true);
            emit panelsChanged();
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









