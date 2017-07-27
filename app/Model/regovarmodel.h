#ifndef REGOVARMODEL_H
#define REGOVARMODEL_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include "project/projectstreeviewmodel.h"
#include "project/projectmodel.h"
#include "file/tusuploader.h"
#include "analysis/filtering/resultstreeviewmodel.h"
#include "analysis/filtering/annotationstreeviewmodel.h"


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
    Q_PROPERTY(FilesTreeViewModel* remoteFilesTreeView READ remoteFilesTreeView NOTIFY remoteFilesTreeViewUpdated)
    Q_PROPERTY(ProjectModel* currentProject READ currentProject  NOTIFY currentProjectUpdated)
    Q_PROPERTY(ResultsTreeViewModel* currentFilteringAnalysis READ currentFilteringAnalysis  NOTIFY currentFilteringAnalysisUpdated)
    Q_PROPERTY(AnnotationsTreeViewModel* currentAnnotations READ currentAnnotations  NOTIFY currentAnnotationsUpdated)

public:
    static RegovarModel* i();
    void init();
    void readSettings();
    void writeSettings();



    // Accessors
    inline QUrl& serverUrl() { return mApiRootUrl; }
    inline ProjectsTreeViewModel* projectsTreeView() const { return mProjectsTreeView; }
    inline FilesTreeViewModel* remoteFilesTreeView() const { return mRemoteFilesTreeView; }
    inline ProjectModel* currentProject() const { return mCurrentProject; }
    inline ResultsTreeViewModel* currentFilteringAnalysis() const { return mCurrentFilteringAnalysis; }
    inline AnnotationsTreeViewModel* currentAnnotations() const { return mCurrentAnnotations; }
    //inline UserModel* currentUser() const { return mUser; }

    // Setters
    inline void setServerUrl(QUrl newUrl) { mApiRootUrl = newUrl; emit serverUrlUpdated(); }


    // Methods
    Q_INVOKABLE void enqueueUploadFile(QList<QString> filesPaths);

public Q_SLOTS:
//    void login(QString& login, QString& password);
//    void logout();
//    void authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);

    void refreshProjectsTreeView();
    void loadProject(int id);
    void loadFilesBrowser();
    void filesEnqueued(QHash<QString,QString> mapping);

Q_SIGNALS:
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();
    void serverUrlUpdated();
    void projectsTreeViewUpdated();
    void remoteFilesTreeViewUpdated();
    void currentProjectUpdated();
    void currentFilteringAnalysisUpdated();
    void currentAnnotationsUpdated();

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
    //! The model used to browse all files available on the server
    FilesTreeViewModel* mRemoteFilesTreeView;
    //! The uploader that manage TUS protocol (resumable upload)
    TusUploader * mUploader;


    //! DEBUG : filtering analysis
    ResultsTreeViewModel* mCurrentFilteringAnalysis;
    AnnotationsTreeViewModel* mCurrentAnnotations;

};


#endif // REGOVARMODEL_H
