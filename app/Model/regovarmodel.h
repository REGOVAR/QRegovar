#ifndef REGOVARMODEL_H
#define REGOVARMODEL_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include "project/projectstreeviewmodel.h"
#include "project/projectmodel.h"


#ifndef regovar
#define regovar (RegovarModel::i())
#endif



/*!
 * \brief Singleton.
 * Main Regovar's client core. Wrap models and manage all interaction with the server
 * (websocket, rest api, tus resumable upload, and so on.
 */
class RegovarModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl serverUrl READ serverUrl WRITE setServerUrl NOTIFY serverUrlUpdated)
    Q_PROPERTY(ProjectsTreeViewModel* projectsTreeView READ projectsTreeView NOTIFY projectsTreeViewUpdated)
    Q_PROPERTY(ProjectModel* currentProject READ currentProject  NOTIFY currentProjectUpdated)

public:
    static RegovarModel* i();
    void init();
    void readSettings();
    void writeSettings();



    // Accessors
    inline QUrl& serverUrl() { return mApiRootUrl; }
    inline ProjectsTreeViewModel* projectsTreeView() const { return mProjectsTreeView; }
    inline ProjectModel* currentProject() const { return mCurrentProject; }
    //inline UserModel* currentUser() const { return mUser; }

    // Setters
    inline void setServerUrl(QUrl newUrl) { mApiRootUrl = newUrl; emit serverUrlUpdated(); }



public Q_SLOTS:
//    void login(QString& login, QString& password);
//    void logout();
//    void authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);

    void refreshProjectsTreeView();
    void loadProject(int id);


Q_SIGNALS:
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();
    void serverUrlUpdated();
    void projectsTreeViewUpdated();
    void currentProjectUpdated();

    void error(QString errCode, QString message);



private:
    RegovarModel();
    ~RegovarModel();
    static RegovarModel* mInstance;



    // Models
    //! The root url to the server api
    QUrl mApiRootUrl;
    //! The current user of the application
    // UserModel * mUser;
    //! The model of the projects browser treeview
    ProjectsTreeViewModel* mProjectsTreeView;
    //! The model of the current project loaded
    ProjectModel* mCurrentProject;


};


#endif // REGOVARMODEL_H
