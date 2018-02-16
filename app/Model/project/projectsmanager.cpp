#include "projectsmanager.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

ProjectsManager::ProjectsManager(QObject* parent) : QObject(parent)
{
    mProjectsTreeModel = new ProjectsTreeModel(this);
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(mProjectsTreeModel);
    mProxy->setFilterRole(ProjectsTreeModel::Roles::SearchField);
    mProxy->setSortRole(ProjectsTreeModel::Roles::Name);
    mProxy->setRecursiveFilteringEnabled(true);
}


void ProjectsManager::refresh()
{
    mProjectsTreeModel->setIsLoading(true);

    Request* request = Request::get("/project/browserTree");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mProjectsTreeModel->refresh(json);
            mProjectsFlatList.clear();
            refreshFlatProjectsListRecursive(json["data"].toArray(), "");
            emit projectsFlatListChanged();

        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build projects tree model (due to request error)";
        }
        mProjectsTreeModel->setIsLoading(false);
        request->deleteLater();
    });
}

void ProjectsManager::refreshFlatProjectsListRecursive(QJsonArray data, QString prefix)
{
    for (const QJsonValue& json: data)
    {
        QJsonObject p = json.toObject();
        QString name = p["name"].toString();
        int id = p["id"].toInt();
        if (id == 0) continue; // do not display trash project in the flat list

        // If folder, need to retrieve subitems recursively
        if (p["is_folder"].toBool())
        {
            refreshFlatProjectsListRecursive(p["children"].toArray(), prefix + name + "/");
        }
        else
        {
            p.insert("fullpath", prefix + name);
            Project* proj =getOrCreateProject(id);
            proj->fromJson(p);
            mProjectsFlatList << proj;
        }
    }
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

    // Notify the view via the update main menu with the project's entry
    regovar->mainMenu()->openMenuEntry(project);
}

void ProjectsManager::deleteProject(int id)
{
    Request* req = Request::del(QString("/project/%1").arg(id));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            refresh();
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}




void ProjectsManager::setSearchQuery(QString)
{
    // TODO : update project treeview according to filter
}
