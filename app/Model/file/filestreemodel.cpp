#include <QDebug>
#include "filestreemodel.h"
#include "filestreeitem.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"


FilesTreeModel::FilesTreeModel(QObject* parent) : TreeModel(parent)
{
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    for (const int roleId: roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);

    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
    mProxy->setRecursiveFilteringEnabled(true);
}



bool FilesTreeModel::fromJson(QJsonArray json)
{
    beginResetModel();
    clear();
    setupModelData(json, mRootItem);
    endResetModel();
    return true;
}


bool FilesTreeModel::refresh()
{
    qDebug() << "TODO: FilesTreeModel::refresh()";
//    Request* request = Request::get("/project/browserTree");
//    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
//    {
//        if (success)
//        {
//            beginResetModel();
//            setupModelData(json["data"].toArray(), rootItem);
//            endResetModel();
//            qDebug() << Q_FUNC_INFO << "done";
//        }
//        else
//        {
//            qCritical() << Q_FUNC_INFO << "Unable to build user list model (due to request error)";
//        }
//        request->deleteLater();
//    });
    return false;
}



void FilesTreeModel::add(File* file, const QModelIndex& index)
{
    beginInsertRows(index, rowCount(index), rowCount(index));
    add(file, getItem(index));
    endInsertRows();
}


void FilesTreeModel::add(File* file, TreeItem* parent)
{
    if (parent == nullptr)
    {
        qDebug() << "ERROR: [FilesTreeModel::add] parent cannot be null";
        return;
    }
    // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
    QHash<int, QVariant> columnData;
    columnData.insert(Id, file->id());
    columnData.insert(Name, file->filenameUI());
    columnData.insert(Comment, file->comment());
    columnData.insert(Url, file->url());
    columnData.insert(UpdateDate, file->updateDate().toString(Qt::LocalDate));
    columnData.insert(Size, file->sizeUI());
    columnData.insert(Status, file->statusUI());
    columnData.insert(Source, file->sourceUI());
    columnData.insert(SearchField, file->searchField());

    // Create treeview item

    TreeItem* item = new TreeItem(columnData, parent);
    parent->appendChild(item);
}



File* FilesTreeModel::getAt(int row, const QModelIndex& parent)
{
    int id = data(index(row, 0, parent), Id).toInt();
    return regovar->filesManager()->getOrCreateFile(id);
}




void FilesTreeModel::setupModelData(QJsonArray data, TreeItem* parent)
{


    for (const QJsonValue& json: data)
    {
        QJsonObject p = json.toObject();

        if (p.contains("folder"))
        {
            // Add folder entry
            // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
            QHash<int, QVariant> columnData;
            columnData.insert(Id, -1);
            columnData.insert(Name, p["name"].toString());
            columnData.insert(Comment, QJsonValue::Null);
            columnData.insert(Url, QJsonValue::Null);
            columnData.insert(UpdateDate, QJsonValue::Null);
            columnData.insert(Size, QJsonValue::Null);
            columnData.insert(Status, QJsonValue::Null);
            columnData.insert(Source, QJsonValue::Null);
            columnData.insert(SearchField, p["name"].toString());

            // Create treeview item
            TreeItem* item = new TreeItem(columnData, parent);
            parent->appendChild(item);

            // Load children
            setupModelData(p["files"].toArray(), item);
        }
        else
        {
            // Add file entry
            int id = p["id"].toInt();
            File* file = regovar->filesManager()->getOrCreateFile(id);
            file->fromJson(p);
            add(file, parent);
        }
    }
}






QHash<int, QByteArray> FilesTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Name] = "name";
    roles[Comment] = "comment";
    roles[Url] = "url";
    roles[UpdateDate] = "updateDate";
    roles[Size] = "size";
    roles[Status] = "status";
    roles[Source] = "source";
    roles[SearchField] = "searchField";
    return roles;
}
