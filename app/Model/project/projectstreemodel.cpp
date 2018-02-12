#include <QDebug>
#include "projectstreemodel.h"
#include "Model/framework/request.h"
#include "Model/framework/treeitem.h"



ProjectsTreeModel::ProjectsTreeModel(QObject* parent) : TreeModel(parent)
{
    // With QML TreeView, the rootItem must know all column's roles to allow correct display for
    // other rows. So that's why we create columns for all existings roles.
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    for (const int roleId: roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);
}




void ProjectsTreeModel::refresh(QJsonObject json)
{
    beginResetModel();
    clear();
    setupModelData(json["data"].toArray(), mRootItem);
    endResetModel();
}






QHash<int, QByteArray> ProjectsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Type] = "type";
    roles[Name] = "name";
    roles[Comment] = "comment";
    roles[Date] = "date";
    roles[Status] = "status";
    roles[SearchField] = "searchField";
    return roles;
}



TreeItem* ProjectsTreeModel::newProjectsTreeItem(bool isFolder, const QJsonObject& rowData, TreeItem* parent)
{
    int id = rowData["id"].toInt();

    // add columns info to the item
    QHash<int, QVariant> columnData;
    columnData.insert(Id, id);
    columnData.insert(Type, isFolder ? "folder" : rowData["type"].toVariant());
    columnData.insert(Name, rowData["name"].toVariant());
    columnData.insert(Comment, rowData["comment"].toVariant());
    QDateTime date = QDateTime::fromString(rowData["update_date"].toString(), Qt::ISODate);
    columnData.insert(Date, QVariant(date.toString("yyyy-MM-dd HH:mm")));
    columnData.insert(Status, isFolder ? QVariant() : rowData["status"].toVariant());
    QString search = rowData["name"].toString() + " " + rowData["comment"].toString() + " " + date.toString("yyyy-MM-dd HH:mm");
    if (isFolder)
    {
        search += " " + rowData["status"].toString();
    }
    columnData.insert(SearchField, QVariant(search));

    TreeItem* result = new TreeItem(parent);
    result->setParent(parent);
    result->setData(columnData);

    return result;
}

void ProjectsTreeModel::setupModelData(QJsonArray data, TreeItem* parent)
{
    for (const QJsonValue& json: data)
    {
        QJsonObject p = json.toObject();

        int id = p["id"].toInt();
        if (id == 0)  continue; // trash project not displayed in the browser

        // Create treeview item with column's data and parent item
        TreeItem* item = newProjectsTreeItem(true, p, parent);
        parent->appendChild(item);



        // If folder, need to retrieve subitems recursively
        if (p["is_folder"].toBool())
        {
            setupModelData(p["children"].toArray(), item);
        }
        // If project, need to build subtree for analyses and subjects
        else if (p["analyses"].toArray().count() > 0)
        {
            setupModelAnalysisData(p["analyses"].toArray(), item);
        }
    }
}

void ProjectsTreeModel::setupModelAnalysisData(QJsonArray data, TreeItem* parent)
{
    for (const QJsonValue& json: data)
    {
        // Create treeview item with column's data and parent item
        TreeItem* item = newProjectsTreeItem(false, json.toObject(), parent);
        parent->appendChild(item);
    }
}
