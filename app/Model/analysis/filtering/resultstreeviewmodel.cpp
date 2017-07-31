#include <QDebug>
#include <QtNetwork>
#include "resultstreeviewmodel.h"
#include "resultstreeviewitem.h"
#include "Model/request.h"
#include "Model/regovarmodel.h"



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
                mFields << uid;
                qDebug() << " - " << uid;
            }
            qDebug() << "Current filter" << data["filter"];
            QJsonDocument doc;
            doc.setArray(data["filter"].toArray());
            mFilter = QString(doc.toJson(QJsonDocument::Indented));
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "Request error ! " ; //<< json["msg"].toString();
        }
        req->deleteLater();
    });
}

//! Add or remove a field to the display result and update or set the order
//! Return the order of the field in the grid
int ResultsTreeViewModel::setField(QString uid, bool isDisplayed, int order)
{
    Annotation* annot = regovar->currentAnnotations()->getAnnotation(uid);

    if (isDisplayed)
    {
        if (order != -1)
        {
            order = qMin(order, mFields.count()-1);
            mFields.removeAll(uid);
            mFields.insert(order, uid);
        }
        else
        {
            mFields.removeAll(uid);
            order = mFields.count()-1;
            mFields << uid;
        }
    }
    else
    {
        order = mFields.indexOf(uid);
        mFields.removeAll(uid);
    }

    annot->setOrder(order);
    emit fieldsUpdated();
    return order;
}




void ResultsTreeViewModel::refresh()
{
    setIsLoading(true);

    QJsonDocument filter = QJsonDocument::fromJson(mFilter.toUtf8());
    QJsonObject body;
    body.insert("filter", filter.array());
    body.insert("fields", QJsonArray::fromStringList(mFields));

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
    // Build role from annotations all annotations available list
    foreach (QString uid, regovar->currentAnnotations()->annotations()->keys())
    {
        roles[roleId] = uid.toUtf8();

        // DEBUG
//        AnnotationModel* annot = regovar->currentAnnotations()->getAnnotation(uid);
//        qDebug() << "role " << roleId << "=" << roles[roleId] << annot->name();

        ++roleId;
    }
    qDebug() << "Result Tree's roles defined : " << roleId - Qt::UserRole - 1 << "roles";
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
        foreach (QString uid, mFields)
        {
            columnData << newResultsTreeViewItem(id, r[uid].toVariant());
        }
        // qDebug() << "Load variant : " << id;

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
    qDebug() << "Result Model Ready :" << parent->childCount() << "items loaded";
}
