#include <QDebug>
#include "filestreeviewmodel.h"
#include "filestreeviewitem.h"
#include "Model/request.h"



FilesTreeViewModel::FilesTreeViewModel() : TreeModel(0)
{
    QList<QVariant> rootData;
    rootData << "Name" << "Status" << "Size" << "Date" << "Comment";
    mRootItem = new TreeItem(rootData);

}




void FilesTreeViewModel::refresh()
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



QVariant FilesTreeViewModel::newFilesTreeViewItem(int id, const QString &text)
{
    FilesTreeViewItem *t = new FilesTreeViewItem(this);
    t->setText(text);
    t->setId(id);
    QVariant v;
    v.setValue(t);
    return v;
}

QVariant FilesTreeViewModel::newFilesTreeViewItemSize(int id, quint64 size, quint64 offset)
{
    if (size == offset)
    {
         return newFilesTreeViewItem(id, humanSize(size));
    }

    QString sOffset = humanSize(offset);
    QString sSize = humanSize(size);
    return newFilesTreeViewItem(id, sOffset + " / " + sSize);
}

QVariant FilesTreeViewModel::newFilesTreeViewItemStatus(int id, QString status, quint64 size, quint64 offset)
{
    if (status == "uploading")
    {
        float progress = (size > 0) ? offset / size * 100 : 0;
        return newFilesTreeViewItem(id, tr("Uploading : ") + QLocale::system().toString(progress, 'f', 1) + " %");
    }

    return newFilesTreeViewItem(id, status);
}


void FilesTreeViewModel::setupModelData(QJsonArray data, TreeItem* parent)
{


    foreach(const QJsonValue json, data)
    {
        QJsonObject p = json.toObject();
        int id = p["id"].toInt();

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QList<QVariant> columnData;
        columnData << newFilesTreeViewItem(id, p["name"].toString());
        columnData << newFilesTreeViewItemStatus(id, p["status"].toString(), p["size"].toInt(), p["upload_offset"].toInt());
        columnData << newFilesTreeViewItemSize(id, p["size"].toInt(), p["upload_offset"].toInt());
        columnData << newFilesTreeViewItem(id, p["comment"].toString());
        columnData << newFilesTreeViewItem(id, QDate::fromString(p["create_date"].toString()).toString(Qt::LocalDate));
        columnData << newFilesTreeViewItem(id, QDate::fromString(p["update_date"].toString()).toString(Qt::LocalDate));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);

    }
}



bool FilesTreeViewModel::fromJson(QJsonArray json)
{
    clear();
    setupModelData(json, mRootItem);
    return true;
}





QString FilesTreeViewModel::humanSize(qint64 nbytes)
{
    QList<QString> suffixes = {"o", "Ko", "Mo", "Go", "To", "Po"};


    if (nbytes <= 0)
    {
        return "O  o";
    }

    auto i=0;
    double bytes = nbytes;
    while( bytes >= 1024 and i < suffixes.count() -1 )
    {
        bytes /= 1024. ;
        i += 1;
    }
    QString f = QLocale::system().toString(bytes, 'f', 2);
    return QString("%1 %2").arg(f).arg(suffixes[i]);
}
