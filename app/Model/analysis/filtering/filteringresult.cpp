#include "filteringresult.h"
/*
FilteringResult::FilteringResult(FilteringAnalysis* parent) : QAbstractListModel(parent)
{
    mFilteringAnalysis = parent;
    QHash<int, QVariant> rootData;
    mRootItem = new TreeItem(rootData);

    mAnalysisId = -1;
    mPagination = 1000; // TODO : load from settings
}



QHash<int, QByteArray> FilteringResult::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[IsSelected] = "isSelected";
    roles[Level] = "level";
    roles[Children] = "children";
    roles[Data] = "data";
    return roles;
}




void FilteringResult::initAnalysisData(int analysisId)
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



//QHash<int, QByteArray> FilteringResult::roleNames() const
//{
//    QHash<int, QByteArray> roles;
//    int roleId = Qt::UserRole + 1;
//    roles[roleId] = "id";
//    ++roleId;
//    roles[roleId] = "is_selected";
//    ++roleId;
//    roles[roleId] = "columns_data";
//    ++roleId;

//    // Build role from annotations all annotations available list
//    for (const QString& uid: mFilteringAnalysis->annotationsMap().keys())
//    {
//        roles[roleId] = uid.toUtf8();
//        ++roleId;
//    }
//    return roles;
//}






//! Reset the Treemodel with data for the current filter set in the FilteringAnalysis
void FilteringResult::applyFilter(QJsonArray filter)
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
            beginResetModel();
            clear();

            QJsonObject data = json["data"].toObject();
            setLoaded(0);
            setTotal(data["wt_total_variants"].toInt()); // , data["wt_total_results"].toInt()
            // Set content (rows)
            setupModelData(data["results"].toArray(), mRootItem);
            endResetModel();
            qDebug() << Q_FUNC_INFO << "Results TreeViewModel reset." << mLoaded << "results loaded";
        }
        else
        {
            regovar->manageRequestError(json, Q_FUNC_INFO);
        }
        setIsLoading(false);
        request->deleteLater();
    });
}



//! Load next result according to the mResultsPagination value (default is 100)
void FilteringResult::loadNext()
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
            regovar->manageRequestError(json, Q_FUNC_INFO);
        }

        // Notify view/model that update is finished
        endInsertRows();
        setIsLoading(false);

        request->deleteLater();
    });
}




//! Create treeview item with provided data, according to the type of the annotation
TreeItem* FilteringResult::newFilteringResultItem(const QJsonObject& rowData)
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
    for (const QString& fuid: mFilteringAnalysis->displayedAnnotations())
    {
        QString type = mFilteringAnalysis->getColumnInfo(fuid)->annotation()->type();
        QString data;
        if (type == "int")
        {
            data = regovar->formatNumber(rowData[fuid].toInt());
        }
        if (type == "float")
        {
            data = regovar->formatNumber(rowData[fuid].toDouble());
        }
        else if (type == "bool")
        {
            data = rowData[fuid].toBool() ? "n" : "h";
        }
        else if (type == "list")
        {
            data = rowData[fuid].toString() + " _l";
        }
        else if (type == "sample_array")
        {
//            QJsonObject meta = mFilteringAnalysis->getColumnInfo(fuid)->annotation()->meta();
//            if (!meta.isEmpty() && meta["type"] == "enum")
//                data = regovar->formatNumber(rowData[fuid].toInt());
//            else
            data = "todo";
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


void FilteringResult::setupModelData(QJsonArray data, TreeItem *parent)
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

*/
