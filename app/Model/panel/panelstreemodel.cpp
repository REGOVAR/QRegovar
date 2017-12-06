#include <QDebug>
#include "panelstreemodel.h"
#include "panelstreeitem.h"
#include "Model/framework/request.h"


PanelsTreeModel::PanelsTreeModel() : TreeModel(nullptr)
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







void PanelsTreeModel::refresh(QJsonObject json)
{
    beginResetModel();
    clear();
    setupModelData(json["data"].toArray(), mRootItem);
    endResetModel();
}






QHash<int, QByteArray> PanelsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Name] = "name";
    roles[Date] = "date";
    roles[Comment] = "comment";
    roles[Shared] = "shared";
    return roles;
}



QVariant PanelsTreeModel::newPanelsTreeItem(int id, const QString& version, const QString& text)
{
    PanelsTreeItem *t = new PanelsTreeItem(this);
    t->setId(id);
    t->setVersion(version);
    t->setText(text);
    QVariant v;
    v.setValue(t);
    return v;
}


void PanelsTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    for (const QJsonValue& json: data)
    {
        QJsonObject p = json.toObject();
        int id = p["id"].toInt();

        QString version;

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(Name, newPanelsTreeItem(id, version, p["name"].toString()));
        columnData.insert(Comment, newPanelsTreeItem(id, version, p["comment"].toString()));
        QDateTime date = QDateTime::fromString(p["update_date"].toString(), Qt::ISODate);
        columnData.insert(Date, newPanelsTreeItem(id, version, date.toString("yyyy-MM-dd HH:mm")));
        columnData.insert(Shared, newPanelsTreeItem(id, version, p["shared"].toBool() ? tr("Yes") : ""));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);

        // Create versions subitems
        for(QJsonValue v: p["versions"].toArray())
        {
            setupModelPanelEntryData(id, v.toObject(), item);
        }
    }
}

void PanelsTreeModel::setupModelPanelEntryData(int panelId, QJsonObject data, TreeItem *parent)
{
    for (const QJsonValue& json: data)
    {
        QJsonObject p = json.toObject();
        QString version = p["version"].toString();


        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(Name, newPanelsTreeItem(panelId, version, p["name"].toString()));
        columnData.insert(Comment, newPanelsTreeItem(panelId, version, p["comment"].toString()));
        columnData.insert(Date, newPanelsTreeItem(panelId, version, p["update_date"].toString()));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
}
