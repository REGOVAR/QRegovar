#include <QDebug>
#include "projectstreemodel.h"
#include "projectstreeitem.h"
#include "Model/request.h"



ProjectsTreeModel::ProjectsTreeModel() : TreeModel(0)
{
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    foreach (int roleId, roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);
    refresh();
}




void ProjectsTreeModel::refresh()
{
    setIsLoading(true);
    Request* request = Request::get("/project/browserTree");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            beginResetModel();
            setupModelData(json["data"].toArray(), mRootItem);
            endResetModel();
            qDebug() << Q_FUNC_INFO << "Projects TreeViewModel refreshed";
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build projects tree model (due to request error)";
        }
        setIsLoading(false);
        request->deleteLater();
    });
}






QHash<int, QByteArray> ProjectsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DateRole] = "date";
    roles[CommentRole] = "comment";
    return roles;
}



QVariant ProjectsTreeModel::newProjectsTreeViewItem(int id, const QString &text)
{
    ProjectsTreeItem *t = new ProjectsTreeItem(this);
    t->setText(text);
    t->setId(id);
    QVariant v;
    v.setValue(t);
    return v;
}

void ProjectsTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    foreach(const QJsonValue json, data)
    {
        QJsonObject p = json.toObject();
        int id = p["id"].toInt();

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(NameRole, newProjectsTreeViewItem(id, p["name"].toString()));
        columnData.insert(CommentRole, newProjectsTreeViewItem(id, p["comment"].toString()));
        columnData.insert(DateRole, newProjectsTreeViewItem(id, p["update_date"].toString()));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
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

void ProjectsTreeModel::setupModelAnalysisData(QJsonArray data, TreeItem *parent)
{
    foreach(const QJsonValue json, data)
    {
        QJsonObject p = json.toObject();
        int id = p["id"].toInt();

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(NameRole, newProjectsTreeViewItem(id, p["name"].toString()));
        columnData.insert(CommentRole, newProjectsTreeViewItem(id, p["comment"].toString()));
        columnData.insert(DateRole, newProjectsTreeViewItem(id, p["update_date"].toString()));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
}
