#include "projectsmanager.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

ProjectsManager::ProjectsManager(QObject* parent) : QObject(parent)
{
    mProjectsTreeView = new ProjectsTreeModel();
}


void ProjectsManager::refresh()
{
    mProjectsTreeView->setIsLoading(true);

    Request* request = Request::get("/project/browserTree");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mProjectsTreeView->refresh(json);
            mProjectsFlatList.clear();
            refreshFlatProjectsListRecursive(json["data"].toArray(), "");

        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build projects tree model (due to request error)";
        }
        mProjectsTreeView->setIsLoading(false);
        request->deleteLater();
    });
}

void ProjectsManager::refreshFlatProjectsListRecursive(QJsonArray data, QString prefix)
{
    for (const QJsonValue& json: data)
    {
        QJsonObject p = json.toObject();
        QString name = p["name"].toString();


        // If folder, need to retrieve subitems recursively
        if (p["is_folder"].toBool())
        {
            refreshFlatProjectsListRecursive(p["children"].toArray(), prefix + name + "/");
        }
        else
        {
            p.insert("fullpath", prefix + name);
            Project* proj = new Project();
            proj->fromJson(p);
            mProjectsFlatList << proj;
        }
    }
    emit projectsFlatListChanged();
}






Project* ProjectsManager::getOrCreateProject(int id)
{
    if (mProjects.contains(id))
    {
        return mProjects[id];
    }
    // else
    Project* newProject = new Project(id);
    mProjects.insert(id, newProject);
    return newProject;
}



void ProjectsManager::newProject(QString name, QString comment)
{
    QJsonObject body;
    body.insert("name", name);
    body.insert("is_folder", false);
    body.insert("comment", comment);

    Request* req = Request::post(QString("/project"), QJsonDocument(body).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            Project* project = getOrCreateProject(data["id"].toInt());
            project->fromJson(data);
            openProject(project->id(), false);
            emit projectCreationDone(true, project->id());

            refresh();
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
            emit projectCreationDone(false, -1);
        }
        req->deleteLater();
    });
}



void ProjectsManager::openProject(int id, bool reload_from_server)
{
    // Get project
    Project* project = getOrCreateProject(id);
    // Refresh / get all information of the project
    if (reload_from_server)
    {
        project->load();
    }

    // Set ref index
    mProjectOpenIndex = mProjectsOpenList.indexOf(project);
    if (mProjectOpenIndex == -1)
    {
        mProjectsOpenList.insert(0, project);
        mProjectOpenIndex = 0;
        mProjectOpen = qobject_cast<Project*>(mProjectsOpenList[mProjectOpenIndex]);
        emit projectsOpenListChanged();
    }
    // Set ref object
    mProjectOpen = qobject_cast<Project*>(mProjectsOpenList[mProjectOpenIndex]);
    // notify view
    emit projectOpenChanged();
}






void ProjectsManager::setSearchQuery(QString)
{
    // TODO : update project treeview according to filter
}
