#include <QDebug>
#include <QtNetwork>
#include "resultstreeviewmodel.h"
#include "resultstreeviewitem.h"
#include "Model/request.h"



ResultsTreeViewModel::ResultsTreeViewModel() : TreeModel(0)
{
    QList<QVariant> rootData;
    rootData << "Id";
    mRootItem = new TreeItem(rootData);



    loadColumnsRolesFromAnnotations();
    refresh();
}


void ResultsTreeViewModel::loadColumnsRolesFromAnnotations()
{
    Request* req = Request::get(QString("/annotation/2"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& data)
    {
        if (success)
        {
            QJsonObject dt = data["data"].toObject();
            dt = dt["db"].toObject();

            foreach(const QJsonValue json, dt["fields"].toObject())
            {
                QJsonObject a = json.toObject();

                QString uid = a["uid"].toString();
                QString dbUid = a["dbuid"].toString();
                QString name = a["name"].toString();
                QString description = a["description"].toString();
                QString type = a["type"].toString();
                QString meta = a["meta"].toString();
                AnnotationModel* annot = new AnnotationModel(uid, dbUid, name, description, type, meta, "");

                mAnnotations.insert(uid, annot);
                mDisplayedAnnotations.append(uid);
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
    body.insert("fields", "[\"816ce7a58b6918652399342e46143386\", "
                          "\"0ec9783c0c626c928005f05956cb3d7b\", "
                          "\"de2b02e8a7f3c77cf55efd18e0832f22\", "
                          "\"ab1e6b068bd1618d0422a462df93f28b\", "
                          "\"66b71b223a449d2369e7d58ec0c7cd5d\", "
                          "\"6cde5e77baebcc9d98c40a720f6c1b82\", "
                          "\"1128307bbf4e5eaaed49939295e877a3\", "
                          "\"6b708da21ca32e8d94ad973ad0a8aaf3\", "
                          "\"b33e172643f14920cee93d25daaa3c7b\", "
                          "\"3ee42adc14f878158deeb74e16131cf5\"]");


    Request* request = Request::post("/analysis/4/filtering", QJsonDocument(body).toJson());

    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            beginResetModel();
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
    foreach (QString uid, mDisplayedAnnotations)
    {
        roles[roleId] = uid.toUtf8();
        ++roleId;
    }
    return roles;
}



QVariant ResultsTreeViewModel::newResultsTreeViewItem(QString uid, const QString &text)
{
    ResultsTreeViewItem *t = new ResultsTreeViewItem(this);
    t->setText(text);
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

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QList<QVariant> columnData;
        foreach (QString uid, mDisplayedAnnotations)
        {
            columnData << newResultsTreeViewItem(uid, r[uid].toString());
        }

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
}
