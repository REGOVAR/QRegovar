#include <QDebug>
#include "projectsbrowsermodel.h"
#include "projectsbrowseritem.h"
#include "Model/request.h"



ProjectsBrowserModel::ProjectsBrowserModel() : TreeModel(0)
{
    QList<QVariant> rootData;
    rootData << "Name" << "Date" << "Comment";
    rootItem = new TreeItem(rootData);

    refresh();
}




void ProjectsBrowserModel::refresh()
{
    Request* request = Request::get("/project/browserTree");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            beginResetModel();
            setupModelData(json["data"].toArray(), rootItem);
            endResetModel();
            qDebug() << Q_FUNC_INFO << "done";
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build user list model (due to request error)";
        }
        request->deleteLater();
    });
}






QHash<int, QByteArray> ProjectsBrowserModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DateRole] = "date";
    roles[CommentRole] = "comment";
    return roles;
}



QVariant ProjectsBrowserModel::newProjectsBrowserItem(int id, const QString &text)
{
    ProjectsBrowserItem *t = new ProjectsBrowserItem(this);
    t->setText(text);
    t->setId(id);
    QVariant v;
    v.setValue(t);
    return v;
}

void ProjectsBrowserModel::setupModelData(QJsonArray data, TreeItem *parent)
{


    foreach(const QJsonValue json, data)
    {
        QJsonObject p = json.toObject();
        int id = p["id"].toInt();

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QList<QVariant> columnData;
        columnData << newProjectsBrowserItem(id, p["name"].toString());
        columnData << newProjectsBrowserItem(id, p["comment"].toString());
        columnData << newProjectsBrowserItem(id, QDate::fromString(p["create_date"].toString()).toString(Qt::LocalDate));
        columnData << newProjectsBrowserItem(id, QDate::fromString(p["update_date"].toString()).toString(Qt::LocalDate));

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
