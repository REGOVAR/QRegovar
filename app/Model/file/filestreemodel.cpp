#include <QDebug>
#include "filestreemodel.h"
#include "filestreeitem.h"
#include "Model/request.h"



FilesTreeModel::FilesTreeModel() : TreeModel(0)
{
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    foreach (int roleId, roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);

}




void FilesTreeModel::refresh()
{
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
}






QHash<int, QByteArray> FilesTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[StatusRole] = "status";
    roles[SizeRole] = "size";
    roles[DateRole] = "date";
    roles[CommentRole] = "comment";
    return roles;
}



QVariant FilesTreeModel::newFilesTreeViewItem(int id, const QString &text)
{
    FilesTreeItem *t = new FilesTreeItem(this);
    t->setText(text);
    t->setId(id);
    QVariant v;
    v.setValue(t);
    return v;
}

QVariant FilesTreeModel::newFilesTreeViewItemSize(int id, quint64 size, quint64 offset)
{
    if (size == offset)
    {
         return newFilesTreeViewItem(id, humanSize(size));
    }

    QString sOffset = humanSize(offset);
    QString sSize = humanSize(size);
    return newFilesTreeViewItem(id, sOffset + " / " + sSize);
}

QVariant FilesTreeModel::newFilesTreeViewItemStatus(int id, QString status, quint64 size, quint64 offset)
{
    if (status == "uploading")
    {
        float progress = (size > 0) ? offset / size * 100 : 0;
        return newFilesTreeViewItem(id, tr("Uploading : ") + QLocale::system().toString(progress, 'f', 1) + " %");
    }

    return newFilesTreeViewItem(id, status);
}


void FilesTreeModel::setupModelData(QJsonArray data, TreeItem* parent)
{


    foreach(const QJsonValue json, data)
    {
        QJsonObject p = json.toObject();
        int id = p["id"].toInt();

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(NameRole, newFilesTreeViewItem(id, p["name"].toString()));
        columnData.insert(StatusRole, newFilesTreeViewItemStatus(id, p["status"].toString(), p["size"].toInt(), p["upload_offset"].toInt()));
        columnData.insert(SizeRole, newFilesTreeViewItemSize(id, p["size"].toInt(), p["upload_offset"].toInt()));
        columnData.insert(CommentRole, newFilesTreeViewItem(id, p["comment"].toString()));
        columnData.insert(DateRole, newFilesTreeViewItem(id, QDate::fromString(p["update_date"].toString()).toString(Qt::LocalDate)));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);

    }
}



bool FilesTreeModel::fromJson(QJsonArray json)
{
    clear();
    setupModelData(json, mRootItem);
    return true;
}





QString FilesTreeModel::humanSize(qint64 nbytes)
{
    QList<QString> suffixes = {"o", "Ko", "Mo", "Go", "To", "Po"};


    if (nbytes <= 0)
    {
        return "O  o";
    }

    auto i=0;
    double bytes = nbytes;
    while( bytes >= 1024 && i < suffixes.count() -1 )
    {
        bytes /= 1024. ;
        i += 1;
    }
    QString f = QLocale::system().toString(bytes, 'f', 2);
    return QString("%1 %2").arg(f).arg(suffixes[i]);
}
