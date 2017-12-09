#include <QDebug>
#include "panelstreemodel.h"
#include "panelstreeitem.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"


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
        QJsonObject pJson = json.toObject();
        int id = pJson["id"].toInt();
        Panel* p = regovar->panelsManager()->getOrCreatePanel(id);
        p->fromJson(pJson);

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(Name,    newPanelsTreeItem(id, "", p->name()));
        columnData.insert(Comment, newPanelsTreeItem(id, "", p->description()));
        columnData.insert(Date,    newPanelsTreeItem(id, "", p->updateDate().toString("yyyy-MM-dd HH:mm")));
        columnData.insert(Shared,  newPanelsTreeItem(id, "", p->shared() ? tr("Yes") : ""));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);

        // Create versions subitems
        setupModelPaneVersionData(p, item);
    }
}

void PanelsTreeModel::setupModelPaneVersionData(Panel* panel, TreeItem *parent)
{
    int id=panel->id();
    for(QString vName: panel->versions())
    {
        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(Name,    newPanelsTreeItem(id, vName, vName));
        columnData.insert(Comment, newPanelsTreeItem(id, vName, ""));
        columnData.insert(Date,    newPanelsTreeItem(id, vName, ""));
        columnData.insert(Shared,  newPanelsTreeItem(id, vName, panel->shared() ? tr("Yes") : ""));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
}
