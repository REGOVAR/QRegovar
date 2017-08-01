#include <QDebug>
#include <QtNetwork>
#include "resultstreemodel.h"
#include "resultstreeitem.h"
#include "Model/request.h"
#include "Model/regovar.h"



ResultsTreeModel::ResultsTreeModel(FilteringAnalysis* parent) : TreeModel(parent)
{
    mFilteringAnalysis = parent;
    QHash<int, QVariant> rootData;
    mRootItem = new TreeItem(rootData);

    mAnalysisId = -1;
}


void ResultsTreeModel::initAnalysisData(int analysisId)
{
    mAnalysisId = analysisId;
    clear();
}

bool ResultsTreeModel::fromJson(QJsonObject json)
{
    qDebug() << "Init results tree model of filtering analysis" << mAnalysisId << ":";

    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    foreach (int roleId, roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);

    return true;
}





void ResultsTreeModel::refresh()
{
    setIsLoading(true);

    QJsonDocument filter = QJsonDocument::fromJson(mFilteringAnalysis->filter().toUtf8());
    QJsonObject body;
    body.insert("filter", filter.array());
    body.insert("fields", QJsonArray::fromStringList(mFilteringAnalysis->fields()));

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






QHash<int, QByteArray> ResultsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int roleId = Qt::UserRole + 1;
    roles[roleId] = "id";
    ++roleId;
    // Build role from annotations all annotations available list
    foreach (QString uid, regovar->currentFilteringAnalysis()->annotations()->annotations()->keys())
    {
        roles[roleId] = uid.toUtf8();

        // DEBUG
//        AnnotationModel* annot = regovar->currentAnnotations()->getAnnotation(uid);
//        qDebug() << "role " << roleId << "=" << roles[roleId] << annot->name();

        ++roleId;
    }
    qDebug() << "Result Tree's roles defined : " << roles.count() << "roles";
    return roles;
}



QVariant ResultsTreeModel::newResultsTreeViewItem(QString uid, const QVariant &value)
{
    ResultsTreeItem *t = new ResultsTreeItem(this);
    t->setValue(value);
    t->setUid(uid);
    QVariant v;
    v.setValue(t);
    return v;
}


void ResultsTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    QHash<int, QByteArray> roles = roleNames();
    foreach(const QJsonValue json, data)
    {
        QJsonObject r = json.toObject();
        QString id = r["id"].toString();
        QHash<int, QVariant> columnData;
        columnData.insert(roles.key("id"), newResultsTreeViewItem(id, QVariant(id)));

        foreach (QString uid, mFilteringAnalysis->fields())
        {
            columnData.insert(roles.key(uid.toUtf8()), newResultsTreeViewItem(id, r[uid].toVariant()));
        }
        // qDebug() << "Load variant : " << id;

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
    qDebug() << "Result Model Ready :" << parent->childCount() << "items loaded";
}
