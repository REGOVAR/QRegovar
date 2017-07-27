#include <QDebug>
#include "projectstreeviewmodel.h"
#include "projectstreeviewitem.h"
#include "Model/request.h"



ProjectsTreeViewModel::ProjectsTreeViewModel() : TreeModel(0)
{
    QList<QVariant> rootData;
    rootData << "Name" << "Date" << "Comment";
    mRootItem = new TreeItem(rootData);

    refresh();
}




void ProjectsTreeViewModel::refresh()
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






QHash<int, QByteArray> ProjectsTreeViewModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DateRole] = "date";
    roles[CommentRole] = "comment";
    return roles;
}



QVariant ProjectsTreeViewModel::newProjectsTreeViewItem(int id, const QString &text)
{
    ProjectsTreeViewItem *t = new ProjectsTreeViewItem(this);
    t->setText(text);
    t->setId(id);
    QVariant v;
    v.setValue(t);
    return v;
}

void ProjectsTreeViewModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    foreach(const QJsonValue json, data)
    {
        QJsonObject p = json.toObject();
        int id = p["id"].toInt();

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QList<QVariant> columnData;
        columnData << newProjectsTreeViewItem(id, p["name"].toString());
        columnData << newProjectsTreeViewItem(id, p["comment"].toString());
        columnData << newProjectsTreeViewItem(id, QDate::fromString(p["create_date"].toString()).toString(Qt::LocalDate));
        columnData << newProjectsTreeViewItem(id, QDate::fromString(p["update_date"].toString()).toString(Qt::LocalDate));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);

        // If folder, need to retrieve subitems recursively
        if (p["is_folder"].toBool())
        {
            setupModelData(p["children"].toArray(), item);
        }
        // If project, need to build subtree for analyses and subjects
        else
        {
            // TODO
        }
    }
}