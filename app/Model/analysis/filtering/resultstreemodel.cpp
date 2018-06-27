#include <QDebug>
#include <QtNetwork>
#include "resultstreemodel.h"
#include "resultstreeitem.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"



ResultsTreeModel::ResultsTreeModel(FilteringAnalysis* parent) : TreeModel(parent)
{
    mFilteringAnalysis = parent;
    QHash<int, QVariant> rootData;
    mRootItem = new TreeItem(rootData);

    mAnalysisId = parent == nullptr ? -1 : parent->id();
    mPagination = 1000; // TODO : load from settings
}


void ResultsTreeModel::initAnalysisData(int analysisId)
{
    qDebug() << "Init results tree model of filtering analysis" << analysisId << ":";
    mAnalysisId = analysisId;
    mRoles = roleNames();
    mAutoLoadingNext = false;

    // With QML TreeView, the rootItem must know all column's roles to allow correct display for
    // other rows. So that's why we create columns for all existings roles.
    QHash<int, QVariant> rootData;
    for (const int roleId: mRoles.keys())
    {
        rootData.insert(roleId, QString(mRoles[roleId]));
    }
    mRootItem->deleteLater();
    mRootItem = new TreeItem(rootData);

    beginResetModel();
    clear();
    setTotal(0);
    setLoaded(0);
    endResetModel();
    setIsLoading(false);
}



QHash<int, QByteArray> ResultsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int roleId = Qt::UserRole + 1;
    roles[roleId] = "id";
    ++roleId;
    roles[roleId] = "is_selected";
    ++roleId;
    roles[roleId] = "columns_data";
    ++roleId;

    // Build role from annotations all annotations available list
    for (const QString& uid: mFilteringAnalysis->annotationsMap().keys())
    {
        roles[roleId] = uid.toUtf8();
        ++roleId;
    }
    return roles;
}


bool ResultsTreeModel::canFetchMore(const QModelIndex& parent) const
{
    // Don't use fetch mechanism to populate treeview roots items
    // Lazy loading managed by ourself (see how loadNext() is called by QML)
    if (!parent.isValid() || parent == QModelIndex())
        return false;

    // for other item, check if variant result pointed by the index have trx
    TreeItem* item = getItem(parent);
    if (item)
        return item->virtualChildCount() > 0 && item->children().count() != item->virtualChildCount() ;
    return false;
}


void ResultsTreeModel::fetchMore(const QModelIndex& parent)
{
    // Check if model is ready
    if (mAnalysisId == -1) return;

    // Don't use fetch mechanism to populate treeview roots items
    // Lazy loading managed by ourself (see how loadNext() is called by QML)
    if (parent == QModelIndex())
        return;



    QJsonObject body;
    body.insert("fields", QJsonArray::fromStringList(mFilteringAnalysis->fields()));
    body.insert("order", QJsonArray::fromStringList(mFilteringAnalysis->order()));

    TreeItem* item = getItem(parent);
    QString itemId = item->data(Qt::UserRole + 1).toString();
    Request* request = Request::post(QString("/analysis/%1/filtering/%2").arg(mAnalysisId).arg(itemId), QJsonDocument(body).toJson());
    connect(request, &Request::responseReceived, [this, request, parent, item](bool success, const QJsonObject& json)
    {
        if (success)
        {
            int count = item->virtualChildCount();
            beginInsertRows(parent, 0, count-1);

            QJsonObject data = json["data"].toObject();
            setLoaded(0);
            setupModelData(data["results"].toArray(), item);
            endInsertRows();
            qDebug() << Q_FUNC_INFO << "Results TreeViewModel insert trx.";
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        setIsLoading(false);
        request->deleteLater();
    });
}

bool ResultsTreeModel::hasChildren(const QModelIndex &parent) const
{
    TreeItem* item = getItem(parent);
    if(item)
        return item->virtualChildCount() > 0;
    return false;
}







//! Reset the Treemodel with data for the current filter set in the FilteringAnalysis
void ResultsTreeModel::applyFilter(QJsonArray filter)
{
    // Check if model is ready
    if (mAnalysisId == -1) return;

    setIsLoading(true);
    mAutoLoadingNext = false; // abord previous "load all" if still in progress

    // Save last applied filter
    regovar->analysesManager()->getFilteringAnalysis(mAnalysisId)->setFilterJson(filter);

    QJsonObject body;
    body.insert("filter", filter);
    body.insert("fields", QJsonArray::fromStringList(mFilteringAnalysis->fields()));
    body.insert("order", QJsonArray::fromStringList(mFilteringAnalysis->order()));
    body.insert("limit", QJsonValue::fromVariant(QVariant(mPagination)));

    Request* request = Request::post(QString("/analysis/%1/filtering").arg(mAnalysisId), QJsonDocument(body).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            loadResults(json["data"].toObject());
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        setIsLoading(false);
        request->deleteLater();
    });
}


void ResultsTreeModel::applySelection()
{
    // Check if model is ready
    if (mAnalysisId == -1) return;

    setIsLoading(true);
    mAutoLoadingNext = false; // abord previous "load all" if still in progress

    Request* request = Request::get(QString("/analysis/%1/selection").arg(mAnalysisId));
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            loadResults(json["data"].toObject());
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        setIsLoading(false);
        request->deleteLater();
    });
}


void ResultsTreeModel::loadResults(QJsonObject data)
{
    // Update samples names
    mSamplesNames = "";
    for (Sample* sample: mFilteringAnalysis->samples())
    {
        mSamplesNames += sample->name() + "\n";
    }
    mSamplesNames = mSamplesNames.left(mSamplesNames.count() - 1);
    emit samplesNamesChanged();

    // Update treeview model
    beginResetModel();
    clear();
    setLoaded(0);
    setTotal(data["wt_total_variants"].toInt()); // , data["wt_total_results"].toInt()
    // Set content (rows)
    setupModelData(data["results"].toArray(), mRootItem);
    endResetModel();
    qDebug() << Q_FUNC_INFO << "Results TreeViewModel reset." << mLoaded << "results loaded";
}



//! To use when new columns have been added, to add info in the model without reseting it
void ResultsTreeModel::reload()
{

}

//! Load next result according to the mResultsPagination value (default is 100)
void ResultsTreeModel::loadNext()
{
    qDebug() << "RESULTS TREEVIEW LOADNEXT !!!!!!!!!!!!!";
    // Find how many entries to load
    int remainder = mTotal - mLoaded;
    int itemsToFetch = qMin(mPagination, remainder);

    // Notify view/model that we are loading new data
    beginInsertRows(QModelIndex(), mLoaded, mLoaded+itemsToFetch-1);
    setIsLoading(true);

    // Request the server to retrieve new entries
    QJsonObject body;
    // No need to resend the filter as it is the same, just fields and pagination information are needed
    body.insert("fields", QJsonArray::fromStringList(mFilteringAnalysis->fields()));
    body.insert("limit", QJsonValue::fromVariant(QVariant(mPagination)));
    body.insert("offset", QJsonValue::fromVariant(QVariant(mLoaded)));

    Request* request = Request::post(QString("/analysis/%1/filtering").arg(mAnalysisId), QJsonDocument(body).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            setupModelData(data["results"].toArray(), mRootItem);

            qDebug() << Q_FUNC_INFO << "Results TreeViewModel load next." << mLoaded << "results loaded";
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }

        // Notify view/model that update is finished
        endInsertRows();
        setIsLoading(false);

        request->deleteLater();
    });
}


//! Load next result according to the mResultsPagination value (default is 100)
void ResultsTreeModel::loadAll()
{
    if (mAutoLoadingNext) return; // load all already in progress

    qDebug() << "RESULTS TREEVIEW LOADALL !!!!!!!!!!!!!";
    mAutoLoadingNext = true;
    loadNext();
}



//QJsonObject ResultsTreeModel::getData(int idx)
//{
//    QJsonObject result;

//    result.insert("index", idx);
//    QJsonArray jd;

//    for(int role: mRoles.keys())
//    {
//        jd.append(data(index(idx, 0), role).toJsonValue());
//    }
//    result.insert("data", jd);


//    return result;
//}



//! Create treeview item with provided data, according to the type of the annotation
TreeItem* ResultsTreeModel::newResultsTreeViewItem(const QJsonObject& rowData)
{
    QString rowId = rowData["id"].toString();
    bool isSelected = rowData["is_selected"].toBool();
    QHash<int, QVariant> columnData;



    // add columns info to the item
    // For optimisation, we do maximum of format conversion one time here. (instead of doing it in QML dynamicaly)
    // QML shall only have to display text type
    columnData.insert(mRoles.key("id"), QVariant(rowId));
    columnData.insert(mRoles.key("is_selected"), QVariant(isSelected));

    QStringList dataAsList;
    for (QObject* o: mFilteringAnalysis->displayedAnnotations())
    {
        FieldColumnInfos* info = qobject_cast<FieldColumnInfos*>(o);
        if (info->annotation() == nullptr) continue;

        QString type = info->annotation()->type();
        QString fuid = info->annotation()->uid();
        QString data;
        if (type == "int")
        {
            data = regovar->formatNumber(rowData[fuid].toInt());
        }
        else if (type == "float")
        {
            data = regovar->formatNumber(rowData[fuid].toDouble());
        }
        else if (type == "bool")
        {
            data = rowData[fuid].toBool() ? "n" : "h";
        }
        else if (type == "list")
        {
            for (QJsonValue v: rowData[fuid].toArray())
            {
                data += v.toString() + ", ";
            }
            data = data.left(data.count() - 2);
        }
        else if (type == "sample_array")
        {

            QJsonObject meta = mFilteringAnalysis->getColumnInfo(fuid)->annotation()->meta();
            QString metaType = !meta.isEmpty() ? meta["type"].toString() : "";
            for (Sample* sample: mFilteringAnalysis->samples())
            {
                QString k = QString::number(sample->id());
                QJsonValue v = rowData[fuid][k];
                if (v.isNull())
                {
                    data += "\n";
                }
                else if (metaType == "int")
                {
                    if (mFilteringAnalysis->getColumnInfo(fuid)->annotation()->name() == "Genotype")
                    {
                        // display :
                        // None => "?"
                        // -50  => "ERR"
                        // -1   => "-"
                        // 0    => ref/ref
                        // 1    => alt/alt
                        // 2    => ref/alt
                        // 3    => alt1/alt2
                        if (v.isNull()) data += "f";
                        else
                        {
                            if (v.toInt() == -50) data += "l";
                            else if (v.toInt() == -1) data += "ð";
                            else if (v.toInt() == 0) data += "í";
                            else if (v.toInt() == 1) data += "ï";
                            else if (v.toInt() == 2) data += "ñ";
                            else if (v.toInt() == 3) data += "ò";
                        }
                        data += "\n";
                    }
                    else
                    {
                        data += regovar->formatNumber(v.toInt()) + "\n";
                    }
                }
                else if (metaType == "float")
                {
                    data += regovar->formatNumber(v.toDouble()) + "\n";
                }
                else if (metaType == "bool")
                {
                    data += (v.toBool() ? "n" : "h");
                    data += "\n";
                }
                else // if (metaType == "enum")
                {
                    data += v.toString() + "\n";
                }
            }
            data = data.left(data.count() - 1);

        }
        // else if (type == "sequence")
        else
        {
            data = rowData[fuid].toString();
        }
        dataAsList << data;
        columnData.insert(mRoles.key(fuid.toUtf8()), QVariant(data));
    }
    columnData.insert(mRoles.key("columns_data"), QVariant(dataAsList));

    ResultsTreeItem* result = new ResultsTreeItem(mFilteringAnalysis);
    result->setUid(rowId);
    result->setIsSelected(isSelected);
    result->setData(columnData);

    if (rowId.contains("_"))
    {
        // Trx row
        result->setVirtualChildCount(0);
    }
    else
    {
        result->setVirtualChildCount(rowData["trx_count"].toInt());
    }

    return result;
}


void ResultsTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    int loaded = 0;
    for (const QJsonValue& json: data)
    {
        // Create treeview item with column's data and parent item
        TreeItem* item = newResultsTreeViewItem(json.toObject());
        parent->appendChild(item);
        ++loaded;
    }
    setLoaded(mLoaded + loaded);
    qDebug() << "Result Model Ready :" << parent->childCount() << "items loaded";
}
