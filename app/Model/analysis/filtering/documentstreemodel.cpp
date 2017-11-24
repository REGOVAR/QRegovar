#include "documentstreemodel.h"


DocumentsTreeModel::DocumentsTreeModel(FilteringAnalysis* parent) : TreeModel(parent)
{
    // With QML TreeView, the rootItem must know all column's roles to allow correct display for
    // other rows. So that's why we create columns for all existings roles.
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    foreach (int roleId, roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);

    beginResetModel();
    clear();
    endResetModel();
    setIsLoading(false);
}

void DocumentsTreeModel::refresh(QJsonObject json)
{
    beginResetModel();
    clear();
    setupModelData(json, mRootItem);
    endResetModel();
}

QHash<int, QByteArray> DocumentsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Info] = "info";
    roles[Name] = "name";
    roles[Size] = "size";
    roles[Date] = "date";
    roles[Comment] = "comment";
    return roles;
}












DocumentsTreeItem* DocumentsTreeModel::newFileTreeViewItem(QJsonObject data, TreeItem* parent)
{
    File* file = regovar->filesManager()->getOrCreateFile(data["id"].toInt());
    file->fromJson(data);

    // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
    QHash<int, QVariant> columnData;
    columnData.insert(Info, data);
    columnData.insert(Name, file->filenameUI());
    columnData.insert(Size, file->sizeUI());
    columnData.insert(Date, file->updateDate());
    columnData.insert(Comment, file->comment());

    // Create item
    return new DocumentsTreeItem(columnData, parent);
}




DocumentsTreeItem* DocumentsTreeModel::newSampleTreeViewItem(QJsonObject data, TreeItem* parent)
{
    QJsonObject label;
    label["name"] = data["name"].toString();
    label["icon"] = "4";
    QDateTime date = QDateTime::fromString(data["update_date"].toString(), Qt::ISODate);

    QJsonObject subject = data["subject"].toObject();
    if (!subject.isEmpty())
    {
        label["subject"] = subject["firstname"].toString() + " " + subject["lastname"].toString();
    }

    // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
    QHash<int, QVariant> columnData;
    columnData.insert(Info, data);
    columnData.insert(Name, label);
    columnData.insert(Size, "");
    columnData.insert(Date, date.toString("yyyy-MM-dd HH:mm"));
    columnData.insert(Comment, data["comment"].toInt());

    // Create item
    DocumentsTreeItem* item = new DocumentsTreeItem(columnData, parent);

    // Subitems
    int childCount = 1;
    QJsonObject file = data["file"].toObject();
    item->appendChild(newFileTreeViewItem(file, item));
    if (!subject.isEmpty())
    {
        foreach(const QJsonValue json, subject["files"].toArray())
        {
            file = json.toObject();
            parent->appendChild(newFileTreeViewItem(file, parent));
            childCount++;
        }
    }
    item->setVirtualChildCount(childCount);

    return item;
}


void DocumentsTreeModel::setupModelData(QJsonObject data, TreeItem *parent)
{
    // First we add samples files (with Subject>sample as folder)
    foreach(const QJsonValue json, data["samples"].toArray())
    {
        QJsonObject sample = json.toObject();
        parent->appendChild(newSampleTreeViewItem(sample, parent));
    }

    // Next we add analysis file
    foreach(const QJsonValue json, data["files"].toArray())
    {
        QJsonObject file = json.toObject();
        parent->appendChild(newFileTreeViewItem(file, parent));
    }
}

