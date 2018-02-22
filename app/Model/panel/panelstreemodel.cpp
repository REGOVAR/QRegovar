#include <QDebug>
#include "panelstreemodel.h"
#include "panelversion.h"
#include "Model/framework/treeitem.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"


PanelsTreeModel::PanelsTreeModel(QObject* parent) : TreeModel(parent)
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







void PanelsTreeModel::refresh(QJsonArray json)
{
    beginResetModel();
    clear();
    setupModelData(json, mRootItem);
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




void PanelsTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    for (const QJsonValue& json: data)
    {
        QJsonObject pJson = json.toObject();
        QString id = pJson["id"].toString();
        Panel* p = regovar->panelsManager()->getOrCreatePanel(id);
        p->fromJson(pJson);

        // Get Json data and store its into item's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(PanelId, QVariant(id));
        columnData.insert(VersionId, QVariant(""));
        columnData.insert(Name,  QVariant(p->name()));
        columnData.insert(Comment, QVariant(p->description()));
        columnData.insert(Date, QVariant(p->updateDate().toString("yyyy-MM-dd HH:mm")));
        columnData.insert(Shared, QVariant(p->shared() ? tr("Yes") : ""));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);

        // Create versions subitems
        setupModelPaneVersionData(p, item);
    }
}

void PanelsTreeModel::setupModelPaneVersionData(Panel* panel, TreeItem *parent)
{
    QString id = panel->panelId();
    for(QString vId: panel->versionsIds())
    {
        Panel* vdata = panel->getVersion(vId);
        // Store data into treeitem's columns (/!\ columns order must respect enum order)
        QHash<int, QVariant> columnData;
        columnData.insert(PanelId, QVariant(id));
        columnData.insert(VersionId, QVariant(vdata->versionId()));
        columnData.insert(Name, QVariant(vdata->version()));
        columnData.insert(Comment, QVariant(vdata->comment()));
        columnData.insert(Date, QVariant(vdata->updateDate().toString("yyyy-MM-dd HH:mm")));
        columnData.insert(Shared, QVariant(panel->shared() ? tr("Yes") : ""));

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
}
