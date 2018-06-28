#include <QDebug>
#include "projectstreemodel.h"
#include "Model/framework/request.h"
#include "Model/framework/treeitem.h"
#include "Model/project/project.h"
#include "Model/analysis/filtering/filteringanalysis.h"



ProjectsTreeModel::ProjectsTreeModel(QObject* parent) : TreeModel(parent)
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




bool ProjectsTreeModel::loadJson(const QJsonArray& json)
{
    beginResetModel();
    clear();
    setupModelData(json, mRootItem);
    endResetModel();
    return true;
}






QHash<int, QByteArray> ProjectsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Type] = "type";
    roles[AnalysisType] = "analysisType";
    roles[Name] = "name";
    roles[Comment] = "comment";
    roles[Date] = "date";
    roles[Status] = "status";
    roles[SearchField] = "searchField";
    return roles;
}



TreeItem* ProjectsTreeModel::newFolderTreeItem(const QJsonObject& data, TreeItem* parent)
{
    int id = data["id"].toInt();
    Project* project = regovar->projectsManager()->getOrCreateProject(id);
    project->loadJson(data);

    // add columns info to the item
    QHash<int, QVariant> columnData;
    columnData.insert(Id, id);
    columnData.insert(Type, "folder");
    columnData.insert(AnalysisType, "");
    columnData.insert(Name, project->name());
    columnData.insert(Comment, project->comment());
    columnData.insert(Date, QVariant(project->updateDate().toString("yyyy-MM-dd HH:mm")));
    columnData.insert(Status, QVariant());
    QString search = project->name() + " " + project->comment() + " " + project->updateDate().toString("yyyy-MM-dd HH:mm");
    columnData.insert(SearchField, QVariant(search));

    TreeItem* result = new TreeItem(parent);
    result->setParent(parent);
    result->setData(columnData);

    return result;
}

TreeItem* ProjectsTreeModel::newAnalysisTreeItem(const Analysis* analysis, TreeItem* parent)
{
    //FilteringAnalysis* analysis = regovar->analysesManager()->getOrCreateFilteringAnalysis(id);

    // add columns info to the item
    QHash<int, QVariant> columnData;
    columnData.insert(Id, analysis->id());
    columnData.insert(Type, analysis->type());
    columnData.insert(AnalysisType, analysis->type()); // todo: for pipeline, give the name-version of the pipe
    columnData.insert(Name, analysis->name());
    columnData.insert(Comment, analysis->comment());
    columnData.insert(Date, QVariant(analysis->updateDate().toString("yyyy-MM-dd HH:mm")));
    columnData.insert(Status, analysis->status());
    QString search = analysis->name() + " " + analysis->comment() + " " + analysis->updateDate().toString("yyyy-MM-dd HH:mm") + " " + analysis->status()+ " " + analysis->type();
    columnData.insert(SearchField, QVariant(search));

    TreeItem* result = new TreeItem(parent);
    result->setParent(parent);
    result->setData(columnData);

    return result;
}


void ProjectsTreeModel::setupModelData(QJsonArray data, TreeItem* parent)
{
    for (const QJsonValue& json: data)
    {
        QJsonObject p = json.toObject();

        int id = p["id"].toInt();
        if (id == 0)  continue; // trash project not displayed in the browser

        // Create treeview item with column's data and parent item
        TreeItem* item = newFolderTreeItem(p, parent);
        parent->appendChild(item);

        // If project, need to build subtree for analyses and jobs
        if (p.contains("analyses_ids") && p["analyses_ids"].toArray().count() > 0)
        {
            for (const QJsonValue& id: p["analyses_ids"].toArray())
            {
                // Create treeview item with column's data and parent item
                if (!id.isNull())
                {
                    Analysis* a = regovar->analysesManager()->getOrCreateFilteringAnalysis(id.toInt());
                    TreeItem* subItem = newAnalysisTreeItem(a, item);
                    item->appendChild(subItem);
                }
            }
        }
        if (p.contains("jobs_ids") && p["jobs_ids"].toArray().count() > 0)
        {
            for (const QJsonValue& id: p["jobs_ids"].toArray())
            {
                if (!id.isNull())
                {
                    Analysis* a = (Analysis*) regovar->analysesManager()->getOrCreatePipelineAnalysis(id.toInt());
                    TreeItem* subItem = newAnalysisTreeItem(a, item);
                    item->appendChild(subItem);
                }
            }
        }

    }
}
