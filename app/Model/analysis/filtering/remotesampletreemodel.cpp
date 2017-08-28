#include <QDebug>
#include <QtNetwork>
#include "remotesampletreemodel.h"
#include "remotesampletreeitem.h"
#include "Model/request.h"
#include "Model/regovar.h"



RemoteSampleTreeModel::RemoteSampleTreeModel(FilteringAnalysis* parent) : TreeModel(parent)
{
    mFilteringAnalysis = parent;

    // Init roles
    mRoles[Qt::UserRole + 1] = "name";
    mRoles[Qt::UserRole + 2] = "comment";
    mRoles[Qt::UserRole + 3] = "status";
    mRoles[Qt::UserRole + 4] = "filename";
    mRoles[Qt::UserRole + 5] = "importDate";
    mRoles[Qt::UserRole + 6] = "subjectId";
    mRoles[Qt::UserRole + 7] = "firstname";
    mRoles[Qt::UserRole + 8] = "lastname";
    mRoles[Qt::UserRole + 9] = "sex";
    mRoles[Qt::UserRole + 10] = "birthday";
    mRoles[Qt::UserRole + 11] = "deathday";

    // Init root item with all roles
    QHash<int, QVariant> rootData;
    foreach (int roleId, mRoles.keys())
    {
        rootData.insert(roleId, QString(mRoles[roleId]));
    }
    mRootItem = new TreeItem(rootData);
}


QHash<int, QByteArray> RemoteSampleTreeModel::roleNames() const
{
    return mRoles;
}









//! Reset the Treemodel with data for the current filter set in the FilteringAnalysis
void RemoteSampleTreeModel::reset()
{
    setIsLoading(true);

    Request* request = Request::post(QString("sample/browserTree/%1").arg(mFilteringAnalysis->refId()));
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            beginResetModel();
            clear();
            setupModelData(json["data"].toArray(), mRootItem);
            qDebug() << Q_FUNC_INFO << "Remote samples TreeViewModel reset.";
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build remote samples tree model (due to request error)";
        }
        setIsLoading(false);
        request->deleteLater();
    });
}










//! Create treeview item with provided data, according to the type of the annotation
QVariant RemoteSampleTreeModel::newRemoteSampleTreeViewItem(Annotation* annot, QString uid, const QJsonValue &value)
{

    RemoteSampleTreeItem *t = new RemoteSampleTreeItem(mFilteringAnalysis);
    t->setValue(value.toVariant());
    t->setUid(uid);
    QVariant v;
    v.setValue(t);
    return v;

}


void RemoteSampleTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    QHash<int, QByteArray> roles = roleNames();
    int loaded = 0;
    foreach(const QJsonValue json, data)
    {
        QJsonObject r = json.toObject();
        int subjectId = r["id"].toInt();
        int sampleId = r["id"].toInt();
        int sampleId = r["id"].toInt();
        QHash<int, QVariant> columnData;

        columnData.insert(roles.key("id"), newRemoteSampleTreeViewItem(nullptr, id, QJsonValue(id)));

        foreach (QString uid, mFilteringAnalysis->fields())
        {
            Annotation* annot = mFilteringAnalysis->annotations()->getAnnotation(uid);
            columnData.insert(roles.key(uid.toUtf8()), newRemoteSampleTreeViewItem(annot, id, r[uid]));
        }
        // qDebug() << "Load variant : " << id;

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
        ++loaded;
    }
    qDebug() << "Result Model Ready :" << parent->childCount() << "items loaded";
}
