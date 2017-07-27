#include <QDebug>
#include <QtNetwork>
#include "resultstreeviewmodel.h"
#include "resultstreeviewitem.h"
#include "Model/request.h"



ResultsTreeViewModel::ResultsTreeViewModel(int analysisId) : TreeModel(0)
{
    mAnalysisId = analysisId;
    QList<QVariant> rootData;
    rootData << "Id";
    mRootItem = new TreeItem(rootData);



    loadAnalysisData();
}


void ResultsTreeViewModel::loadAnalysisData()
{
    Request* req = Request::get(QString("/analysis/%1").arg(mAnalysisId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Display field :";
            QJsonObject data = json["data"].toObject();

            foreach (const QJsonValue field, data["fields"].toArray())
            {
                QString uid = field.toString();
                mDisplayedAnnotations << uid;
                qDebug() << " - " << uid;
            }
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "Request error ! " ; //<< json["msg"].toString();
        }
        req->deleteLater();
    });
}




void ResultsTreeViewModel::refresh()
{
    setIsLoading(true);

    QJsonObject body;


    body.insert("filter", "[\"AND\",[]]");
    body.insert("fields", QJsonArray::fromStringList(mDisplayedAnnotations));


    Request* request = Request::post(QString("/analysis/%1/filtering").arg(mAnalysisId), QJsonDocument(body).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            beginResetModel();
            clear();
            setupModelData(json["data"].toArray(), mRootItem);
            endResetModel();
            qDebug() << Q_FUNC_INFO << "Results TreeViewModel refreshed";
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build results tree model (due to request error)";
        }
        setIsLoading(false);
        request->deleteLater();
    });
}






QHash<int, QByteArray> ResultsTreeViewModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int roleId = Qt::UserRole + 1;
    roles[roleId] = "id";
    ++roleId;
    foreach (QString uid, mDisplayedAnnotations)
    {
        roles[roleId] = uid.toUtf8();
        qDebug() << "role " << roles[roleId] << "=" << roleId;
        ++roleId;
    }
    return roles;
}



QVariant ResultsTreeViewModel::newResultsTreeViewItem(QString uid, const QVariant &value)
{
    ResultsTreeViewItem *t = new ResultsTreeViewItem(this);
    t->setValue(value);
    t->setUid(uid);
    QVariant v;
    v.setValue(t);
    return v;
}


void ResultsTreeViewModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    foreach(const QJsonValue json, data)
    {
        QJsonObject r = json.toObject();
        QString id = r["id"].toString();

        // Get Json data and store its into item's columns (/!\ columns order must respect role order)
        QList<QVariant> columnData;
        columnData << newResultsTreeViewItem(id, QVariant(id));
        foreach (QString uid, mDisplayedAnnotations)
        {
            columnData << newResultsTreeViewItem(id, r[uid].toVariant());
        }
        qDebug() << "Load variant : " << id;

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
}
