#include <QDebug>
#include "filestreeviewmodel.h"
#include "filestreeviewitem.h"
#include "Model/request.h"



FilesTreeViewModel::FilesTreeViewModel() : TreeModel(0)
{
    QList<QVariant> rootData;
    rootData << "Name" << "Status" << "Size" << "Date" << "Comment";
    rootItem = new TreeItem(rootData);

    refresh();
}




void FilesTreeViewModel::refresh()
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






QHash<int, QByteArray> FilesTreeViewModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[StatusRole] = "status";
    roles[SizeRole] = "size";
    roles[DateRole] = "date";
    roles[CommentRole] = "comment";
    return roles;
}



QVariant FilesTreeViewModel::newFilesBrowserItem(int id, const QString &text, qint64 size, qint64 uploadOffset)
{
    FilesTreeViewItem *t = new FilesTreeViewItem(this);
    t->setText(text);
    t->setId(id);
    t->setSize(size);
    t->setUploadOffset(uploadOffset);
    QVariant v;
    v.setValue(t);
    return v;
}

void FilesTreeViewModel::setupModelData(QJsonArray data, TreeItem *parent)
{


    foreach(const QJsonValue json, data)
    {
        QJsonObject p = json.toObject();
        int id = p["id"].toInt();

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QList<QVariant> columnData;
        columnData << newFilesBrowserItem(id, p["name"].toString());
        columnData << newFilesBrowserItem(id, p["status"].toString(), p["size"].toInt(), p["upload_offset"].toInt());
        columnData << newFilesBrowserItem(id, "", p["size"].toInt(), p["upload_offset"].toInt());
        columnData << newFilesBrowserItem(id, p["comment"].toString());
        columnData << newFilesBrowserItem(id, QDate::fromString(p["create_date"].toString()).toString(Qt::LocalDate));
        columnData << newFilesBrowserItem(id, QDate::fromString(p["update_date"].toString()).toString(Qt::LocalDate));

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
