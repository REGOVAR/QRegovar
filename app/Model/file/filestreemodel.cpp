#include <QDebug>
#include "filestreemodel.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"
#include "Model/framework/treeitem.h"


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


void FilesTreeModel::refreshTreeView()
{
    // invalidating the whole tree
    beginResetModel();
    endResetModel();
//    TreeItem* test = getItem(QModelIndex());

//    QModelIndex idx1 = index(0,0);
//    QModelIndex idx2 = index(1,0);

//    emit dataChanged(idx1, idx2);
}


bool FilesTreeModel::loadJson(QJsonArray json)
{
    beginResetModel();

    for(const int fileId: mFilesIds)
    {
        File* file = regovar->filesManager()->getOrCreateFile(fileId);
        disconnect(file, SIGNAL(dataChanged()), this, SLOT(refreshTreeView()));
    }

    clear();
    setupModelData(json, mRootItem);
    endResetModel();
    return true;
}

void FilesTreeModel::clear()
{
    beginResetModel();
    mRootItem->recursiveDelete();
    mFilesIds.clear();
    endResetModel();
}




void FilesTreeModel::add(File* file, const QModelIndex& index)
{
    if (file!= nullptr)
    {
        beginInsertRows(index, rowCount(index), rowCount(index));
        add(file, getItem(index));
        endInsertRows();
    }
}


void FilesTreeModel::add(File* file, TreeItem* parent)
{
    if (parent == nullptr || file == nullptr)
    {
        qDebug() << "ERROR: [FilesTreeModel::add] parent or file cannot be null";
        return;
    }
    if (mFilesIds.contains(file->id()))
    {
        qDebug() << "File already added in the treeview";
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

    // connect to file data changed event to force the treeview to update itself
    connect(file,  SIGNAL(dataChanged()), this, SLOT(refreshTreeView()));

    // Create treeview item
    TreeItem* item = new TreeItem(columnData, parent);
    parent->appendChild(item);
    mFilesIds.append(file->id());
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
            file->loadJson(p);
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
