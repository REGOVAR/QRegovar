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
    mPagination = 100; // TODO : load from settings
}


void ResultsTreeModel::initAnalysisData(int analysisId)
{
    mAnalysisId = analysisId;

    beginResetModel();
    clear();
    setTotal(0);
    setLoaded(0);
    endResetModel();
}



QHash<int, QByteArray> ResultsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int roleId = Qt::UserRole + 1;
    roles[roleId] = "id";
    ++roleId;
    roles[roleId] = "checked";
    ++roleId;
    // Build role from annotations all annotations available list
    foreach (QString uid, mFilteringAnalysis->annotations()->annotations()->keys())
    {
        roles[roleId] = uid.toUtf8();
        ++roleId;
    }
    qDebug() << "Result Tree's roles defined : " << roles.count() << "roles";
    return roles;
}


bool ResultsTreeModel::canFetchMore(const QModelIndex& parent) const
{
    // Don't use fetch mechanism to populate treeview roots items
    // Lazy loading managed by ourself (see how loadNext() is called by QML)
//    if (parent == QModelIndex())
//        return false;

    // for other item, check if variant result pointed by the index have trx
//    TreeItem* item = getItem(parent);
//    return false; //item->virtualChildCount() > 0;

    return (mLoaded < mTotal);
}


void ResultsTreeModel::fetchMore(const QModelIndex& parent)
{
    // Don't use fetch mechanism to populate treeview roots items
    // Lazy loading managed by ourself (see how loadNext() is called by QML)
//    if (parent == QModelIndex())
//        return ;


//    TreeItem* item = getItem(parent);
//    QVariant itemId = item->data(Qt::UserRole + 1);
    loadNext();
}


//void ResultsTreeModel::fetchMore(const QModelIndex &parent)
//{
//    if (parent == QModelIndex())
//        return ;

//    TreeItem* item = getItem(parent);

//    int count       = item->virtualChildCount();
//    int parentRow   = parent.row();
//    QStringList ids = mRecords[parent.row()].value("childs").toString().split(",");


//    qDebug()<<ids;

//    beginInsertRows(parent,0, count-1);
//    mChilds[parentRow].clear();

//    cvar::VariantQuery temp = mCurrentQuery;
//    temp.setCondition(QString("%2.id IN (%1)").arg(ids.join(",")).arg(mCurrentQuery.table()));
//    temp.setGroupBy({});
//    temp.setNoLimit();

//    QSqlQuery query = cutevariant->sqliteManager()->variants(temp);

//    while (query.next())
//    {
//        mChilds[parentRow].append(query.record());
//    }


//    qDebug()<<query.lastError().text();
//    qDebug()<<query.lastQuery();

//    endInsertRows();
//}

////---------------------------------------------------------------------------
//void ResultsTreeModel::sort(int column, Qt::SortOrder order)
//{

//    if (column < columnCount()) {
//        QString col = headerData(column, Qt::Horizontal, Qt::DisplayRole).toString();
//        qDebug()<<col;
//        mCurrentQuery.setOrderBy({col});
//        mCurrentQuery.setSortOrder(order);
//        load();
//    }

//}
////---------------------------------------------------------------------------





bool ResultsTreeModel::fromJson(QJsonObject)
{
    qDebug() << "Init results tree model of filtering analysis" << mAnalysisId << ":";

    // With QML TreeView, the rootItem must know all column's roles to allow correct display for
    // other rows. So that's why we create columns for all existings roles.
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    foreach (int roleId, roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);

    return true;
}




//! Reset the Treemodel with data for the current filter set in the FilteringAnalysis
void ResultsTreeModel::reset()
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
            setLoaded(0);
            setTotal(0);
            setupModelData(json["data"].toArray(), mRootItem);
            qDebug() << Q_FUNC_INFO << "Results TreeViewModel reset." << mLoaded << "results loaded";
            if (mLoaded < mPagination)
            {
                setTotal(mLoaded);
                endResetModel();
            }
            else
            {
                // Get total number of result
                QJsonDocument filter = QJsonDocument::fromJson(mFilteringAnalysis->filter().toUtf8());
                QJsonObject body;
                body.insert("filter", filter.array());
                body.insert("fields", QJsonArray::fromStringList(mFilteringAnalysis->fields()));

                Request* request = Request::post(QString("/analysis/%1/filtering/count").arg(mAnalysisId), QJsonDocument(body).toJson());
                connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
                {
                    if (success)
                    {
                        setTotal(json["data"].toInt());
                        qDebug() <<mTotal << "results total";
                    }
                    else
                    {
                        qDebug() << "fail to get total results";
                    }

                    endResetModel();
                    request->deleteLater();
                });
            }
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        setIsLoading(false);
        request->deleteLater();
    });
}


//! To use when new columns have been added, to add info in the model without reseting it
void ResultsTreeModel::reload()
{

}

//! Load next result according to the mResultsPagination value (default is 100)
void ResultsTreeModel::loadNext()
{
    // Find how many entries to load
    int remainder = mTotal - mLoaded;
    int itemsToFetch = qMin(mPagination, remainder);

    // Notify view/model that we are loading new data
    beginInsertRows(QModelIndex(), mLoaded, mLoaded+itemsToFetch-1);
    setIsLoading(true);

    // Request the server to retrieve new entries
    QJsonDocument filter = QJsonDocument::fromJson(mFilteringAnalysis->filter().toUtf8());
    QJsonObject body;
    body.insert("filter", filter.array());
    body.insert("fields", QJsonArray::fromStringList(mFilteringAnalysis->fields()));
    body.insert("limit", QJsonValue::fromVariant(QVariant(mPagination)));
    body.insert("offset", QJsonValue::fromVariant(QVariant(mLoaded)));

    Request* request = Request::post(QString("/analysis/%1/filtering").arg(mAnalysisId), QJsonDocument(body).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            setupModelData(json["data"].toArray(), mRootItem);

            qDebug() << Q_FUNC_INFO << "Results TreeViewModel load next." << mLoaded << "results loaded";
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }

        // Notify view/model that update is finished
        endInsertRows();
        setIsLoading(false);

        request->deleteLater();
    });
}








//! Create treeview item with provided data, according to the type of the annotation
QVariant ResultsTreeModel::newResultsTreeViewItem(Annotation* annot, QString uid, const QJsonValue &value)
{

    if (annot != nullptr && annot->type() == "sample_array")
    {
        QJsonObject meta = annot->meta();
        ResultsTreeItem4SampleArray *t = new ResultsTreeItem4SampleArray(mFilteringAnalysis);
        t->setUid(uid);
        t->setType(meta["type"].toString());

        QJsonObject data = value.toObject();



        foreach (QString sampleId, data.keys())
        {
            int a = sampleId.toInt();
            QVariant b = data[sampleId].toVariant();
            t->samplesValues()->insert(a, b);
        }
        t->refreshDisplayedValues();
        QVariant v;
        v.setValue(t);
        return v;
    }
    else
    {
        ResultsTreeItem *t = new ResultsTreeItem(mFilteringAnalysis);
        t->setValue(value.toVariant());
        t->setUid(uid);
        QVariant v;
        v.setValue(t);
        return v;
    }
}


void ResultsTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    QHash<int, QByteArray> roles = roleNames();
    int loaded = 0;
    foreach(const QJsonValue json, data)
    {
        QJsonObject r = json.toObject();
        QString id = r["id"].toString();
        QHash<int, QVariant> columnData;

        columnData.insert(roles.key("id"), newResultsTreeViewItem(nullptr, id, QJsonValue(id)));

        foreach (QString uid, mFilteringAnalysis->fields())
        {
            Annotation* annot = mFilteringAnalysis->annotations()->getAnnotation(uid);
            columnData.insert(roles.key(uid.toUtf8()), newResultsTreeViewItem(annot, id, r[uid]));
        }
        // qDebug() << "Load variant : " << id;

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
        ++loaded;
    }
    setLoaded(mLoaded + loaded);
    qDebug() << "Result Model Ready :" << parent->childCount() << "items loaded";
}
