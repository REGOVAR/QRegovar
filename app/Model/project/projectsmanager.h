#ifndef PROJECTSMANAGER_H
#define PROJECTSMANAGER_H

#include <QtCore>
#include "project.h"
#include "projectstreemodel.h"

class ProjectsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)
    Q_PROPERTY(ProjectsTreeModel* projectsTreeView READ projectsTreeView NOTIFY neverChanged)
    Q_PROPERTY(QList<QObject*> projectsFlatList READ projectsFlatList NOTIFY projectsFlatListChanged)

public:
    // Constructor
    explicit ProjectsManager(QObject* parent = nullptr);

    // Getters
    inline QString searchQuery() const { return mSearchQuery; }
    inline ProjectsTreeModel* projectsTreeView() const { return mProjectsTreeView; }
    inline QList<QObject*> projectsFlatList() const { return mProjectsFlatList; }

    // Setters
    void setSearchQuery(QString val);

    // Methods
    Q_INVOKABLE Project* getOrCreateProject(int id);
    Q_INVOKABLE void newProject(QString name, QString comment);
    Q_INVOKABLE void openProject(int id, bool reload_from_server=true);
    Q_INVOKABLE void deleteProject(int id);


public Q_SLOTS:
    //! Refresh projects list (Treeview model and flat list)
    void refresh();

Q_SIGNALS:
    void neverChanged();
    // Property changed event
    void searchQueryChanged();
    void projectsFlatListChanged();
    //! Event on project creation done (sync with server done)
    void projectCreationDone(bool success, int projectId);

private:
    //! Internal list of all loaded project
    QHash<int, Project*> mProjects;
    //! The model of the projects browser treeview
    ProjectsTreeModel* mProjectsTreeView = nullptr;
    //! The flat list of project (=mProjectsTreeView but as list. Use for project's combobox selection)
    QList<QObject*> mProjectsFlatList;
    //! Query use to search projects in the browser
    QString mSearchQuery;


    int mSelectedProject;

    // Internal method
    void refreshFlatProjectsListRecursive(QJsonArray data, QString prefix);
};

#endif // PROJECTSMANAGER_H
