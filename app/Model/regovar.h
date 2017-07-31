#ifndef REGOVAR_H
#define REGOVAR_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include "project/projectstreemodel.h"
#include "project/project.h"
#include "file/tusuploader.h"
#include "analysis/filtering/resultstreemodel.h"
#include "analysis/filtering/annotationstreemodel.h"
#include "analysis/filtering/quickfilters/quickfiltermodel.h"


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
    Q_PROPERTY(ProjectsTreeModel* projectsTreeView READ projectsTreeView NOTIFY projectsTreeViewUpdated)
    Q_PROPERTY(FilesTreeModel* remoteFilesTreeView READ remoteFilesTreeView NOTIFY remoteFilesTreeViewUpdated)
    Q_PROPERTY(Project* currentProject READ currentProject  NOTIFY currentProjectUpdated)
    Q_PROPERTY(ResultsTreeModel* currentFilteringAnalysis READ currentFilteringAnalysis  NOTIFY currentFilteringAnalysisUpdated)
    Q_PROPERTY(AnnotationsTreeModel* currentAnnotations READ currentAnnotations  NOTIFY currentAnnotationsUpdated)
    Q_PROPERTY(QuickFilterModel* currentQuickFilters READ currentQuickFilters  NOTIFY currentQuickFiltersUpdated)

public:
    static Regovar* i();
    void init();
    void readSettings();
    void writeSettings();



    // Accessors
    inline QUrl& serverUrl() { return mApiRootUrl; }
    inline ProjectsTreeModel* projectsTreeView() const { return mProjectsTreeView; }
    inline FilesTreeModel* remoteFilesTreeView() const { return mRemoteFilesTreeView; }
    inline Project* currentProject() const { return mCurrentProject; }
    inline ResultsTreeModel* currentFilteringAnalysis() const { return mCurrentFilteringAnalysis; }
    inline AnnotationsTreeModel* currentAnnotations() const { return mCurrentAnnotations; }
    inline QuickFilterModel* currentQuickFilters() const { return mCurrentQuickFilters; }
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
    void currentQuickFiltersUpdated();

    void error(QString errCode, QString message);



private:
    Regovar();
    ~Regovar();
    static Regovar* mInstance;



    // Models
    //! The root url to the server api
    QUrl mApiRootUrl;
    //! The current user of the application
    // UserModel * mUser;
    //! The model of the projects browser treeview
    ProjectsTreeModel* mProjectsTreeView;
    //! The model of the current project loaded
    Project* mCurrentProject;
    //! The model used to browse all files available on the server
    FilesTreeModel* mRemoteFilesTreeView;
    //! The uploader that manage TUS protocol (resumable upload)
    TusUploader * mUploader;


    //! DEBUG : filtering analysis
    ResultsTreeModel* mCurrentFilteringAnalysis;
    AnnotationsTreeModel* mCurrentAnnotations;
    QuickFilterModel* mCurrentQuickFilters;

};


#endif // REGOVAR_H
