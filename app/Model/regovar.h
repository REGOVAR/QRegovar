#ifndef REGOVAR_H
#define REGOVAR_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include "project/projectstreemodel.h"
#include "project/project.h"
#include "file/tusuploader.h"
#include "analysis/filtering/filteringanalysis.h"


#ifndef regovar
#define regovar (Regovar::i())
#endif



/*!
 * \brief Singleton.
 * Main Regovar's client core. Wrap models and manage all interaction with the server
 * (websocket, rest api, tus resumable upload, and so on.
 */
class Regovar : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl serverUrl READ serverUrl WRITE setServerUrl NOTIFY serverUrlUpdated)
    Q_PROPERTY(QString searchRequest READ searchRequest WRITE setSearchRequest NOTIFY searchRequestUpdated)
    Q_PROPERTY(ProjectsTreeModel* projectsTreeView READ projectsTreeView NOTIFY projectsTreeViewUpdated)
    Q_PROPERTY(FilesTreeModel* remoteFilesTreeView READ remoteFilesTreeView NOTIFY remoteFilesTreeViewUpdated)
    Q_PROPERTY(Project* currentProject READ currentProject  NOTIFY currentProjectUpdated)
    Q_PROPERTY(FilteringAnalysis* currentFilteringAnalysis READ currentFilteringAnalysis NOTIFY currentFilteringAnalysisUpdated)

public:
    static Regovar* i();
    void init();
    void readSettings();
    void writeSettings();



    // Accessors
    inline QUrl& serverUrl() { return mApiRootUrl; }
    inline QString searchRequest() { return mSearchRequest; }
    inline ProjectsTreeModel* projectsTreeView() const { return mProjectsTreeView; }
    inline FilesTreeModel* remoteFilesTreeView() const { return mRemoteFilesTreeView; }
    inline Project* currentProject() const { return mCurrentProject; }
    inline FilteringAnalysis* currentFilteringAnalysis() const { return mCurrentFilteringAnalysis; }
    //inline UserModel* currentUser() const { return mUser; }

    // Setters
    inline void setServerUrl(QUrl newUrl) { mApiRootUrl = newUrl; emit serverUrlUpdated(); }
    inline void setSearchRequest(QString searchRequest) { mSearchRequest = searchRequest; emit searchRequestUpdated(); }


    // Methods
    Q_INVOKABLE void enqueueUploadFile(QList<QString> filesPaths);
    Q_INVOKABLE void error(QJsonObject error);
    Q_INVOKABLE void close();
    Q_INVOKABLE void disconnectUser();
    Q_INVOKABLE void quit();

public Q_SLOTS:
//    void login(QString& login, QString& password);
//    void logout();
//    void authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);

    void refreshProjectsTreeView();
    void loadFilesBrowser();
    void filesEnqueued(QHash<QString,QString> mapping);

    void loadProject(int id);
    void loadAnalysis(int id);

Q_SIGNALS:
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();
    void searchRequestUpdated();
    void serverUrlUpdated();
    void projectsTreeViewUpdated();
    void remoteFilesTreeViewUpdated();
    void currentProjectUpdated();
    void currentFilteringAnalysisUpdated();
    void onClose();
    void onError(QString errCode, QString message);



private:
    Regovar();
    ~Regovar();
    static Regovar* mInstance;



    // Models
    //! The root url to the server api
    QUrl mApiRootUrl;
    //! The current user of the application
    // UserModel * mUser;
    //! Search request and results
    QString mSearchRequest;
    QStringList* mSearchResult;

    //! The model of the projects browser treeview
    ProjectsTreeModel* mProjectsTreeView;
    //! The model of the current project loaded
    Project* mCurrentProject;
    //! The model used to browse all files available on the server
    FilesTreeModel* mRemoteFilesTreeView;
    //! The uploader that manage TUS protocol (resumable upload)
    TusUploader * mUploader;
    //! Filtering analysis
    FilteringAnalysis* mCurrentFilteringAnalysis;

};


#endif // REGOVAR_H
