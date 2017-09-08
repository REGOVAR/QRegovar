#ifndef REGOVAR_H
#define REGOVAR_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include <QQmlApplicationEngine>
#include "project/projectstreemodel.h"
#include "project/project.h"
#include "file/tusuploader.h"
#include "analysis/filtering/filteringanalysis.h"
#include <QtWebSockets/QtWebSockets>

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

    Q_PROPERTY(QUrl serverUrl READ serverUrl WRITE setServerUrl NOTIFY serverUrlChanged)
    Q_PROPERTY(QString searchRequest READ searchRequest WRITE setSearchRequest NOTIFY searchRequestChanged)
    Q_PROPERTY(QJsonObject searchResult READ searchResult NOTIFY searchResultChanged)
    Q_PROPERTY(bool searchInProgress READ searchInProgress NOTIFY searchInProgressChanged)
    Q_PROPERTY(ProjectsTreeModel* projectsTreeView READ projectsTreeView NOTIFY projectsTreeViewChanged)
    Q_PROPERTY(FilesTreeModel* remoteFilesTreeView READ remoteFilesTreeView NOTIFY remoteFilesTreeViewChanged)
    Q_PROPERTY(Project* currentProject READ currentProject NOTIFY currentProjectChanged)
    Q_PROPERTY(QJsonArray lastAnalyses READ lastAnalyses NOTIFY lastAnalysesChanged)
    Q_PROPERTY(QJsonArray lastEvent READ lastEvent NOTIFY lastEventChanged)
    Q_PROPERTY(QJsonArray lastSubjects READ lastSubjects NOTIFY lastSubjectsChanged)

public:
    static Regovar* i();
    void init();
    void readSettings();
    void writeSettings();

    // Accessors
    inline QUrl& serverUrl() { return mApiRootUrl; }
    inline QString searchRequest() { return mSearchRequest; }
    inline QJsonObject searchResult() const { return mSearchResult; }
    inline bool searchInProgress() const { return mSearchInProgress; }
    inline ProjectsTreeModel* projectsTreeView() const { return mProjectsTreeView; }
    inline FilesTreeModel* remoteFilesTreeView() const { return mRemoteFilesTreeView; }
    inline Project* currentProject() const { return mCurrentProject; }
    inline QJsonArray lastAnalyses() const { return mLastAnalyses; }
    inline QJsonArray lastEvent() const { return mLastEvents; }
    inline QJsonArray lastSubjects() const { return mLastSubjects; }
    //inline UserModel* currentUser() const { return mUser; }

    // Setters
    inline void setServerUrl(QUrl newUrl) { mApiRootUrl = newUrl; emit serverUrlChanged(); }
    inline void setSearchRequest(QString searchRequest) { mSearchRequest = searchRequest; emit searchRequestChanged(); }
    inline void setSearchResult(QJsonObject searchResult) { mSearchResult = searchResult; emit searchResultChanged(); }
    inline void setSearchInProgress(bool flag) { mSearchInProgress = flag; emit searchInProgressChanged(); }
    inline void setQmlEngine (QQmlApplicationEngine* engine) { mQmlEngine = engine; }

    // Methods
    Q_INVOKABLE void newProject(QString name, QString comment);
    Q_INVOKABLE void newAnalysis(QJsonObject data);
    Q_INVOKABLE void newSubject(QJsonObject data);
    Q_INVOKABLE void enqueueUploadFile(QList<QString> filesPaths);
    Q_INVOKABLE void raiseError(QJsonObject raiseError);
    Q_INVOKABLE void close();
    Q_INVOKABLE void disconnectUser();
    Q_INVOKABLE void quit();
    Q_INVOKABLE void openAnalysis(int analysisId);
    Q_INVOKABLE FilteringAnalysis* getAnalysisFromWindowId(int winId);
    Q_INVOKABLE void search(QString query);
    Q_INVOKABLE void getWelcomLastData();



public Q_SLOTS:
//    void login(QString& login, QString& password);
//    void logout();
    void authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);

    void refreshProjectsTreeView();
    void loadFilesBrowser();
    void filesEnqueued(QHash<QString,QString> mapping);

    void loadProject(int id);
    void loadAnalysis(int id);

    // Websocket
    void websocketConnected();
    void websocketClosed();
    void websocketMessageReceived(QString message);


signals:
Q_SIGNALS:
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();
    void searchRequestChanged();
    void searchResultChanged();
    void searchInProgressChanged();
    void serverUrlChanged();
    void projectsTreeViewChanged();
    void remoteFilesTreeViewChanged();
    void currentProjectChanged();
    void onClose();
    void onError(QString errCode, QString message);
    void projectCreationDone(bool success, int projectId);
    void analysisCreationDone(bool success, int analysisId);
    void subjectCreationDone(bool success, int subjectId);
    void lastAnalysesChanged();
    void lastEventChanged();
    void lastSubjectsChanged();

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
    QJsonObject mSearchResult;
    bool mSearchInProgress = false;

    //! The model of the projects browser treeview
    ProjectsTreeModel* mProjectsTreeView;
    //! The model of the current project loaded
    Project* mCurrentProject;
    //! The model used to browse all files available on the server
    FilesTreeModel* mRemoteFilesTreeView;
    //! The uploader that manage TUS protocol (resumable upload)
    TusUploader * mUploader;
    //! Filtering analyses
    QList<FilteringAnalysis*> mOpenAnalyses;
    //! Welcom last data
    QJsonArray mLastEvents;
    QJsonArray mLastAnalyses;
    QJsonArray mLastSubjects;


    //! We need ref to the QML engine to create/open new windows for Analysis
    QQmlApplicationEngine* mQmlEngine;

    //! Websocket
    QWebSocket mWebSocket;
    QUrl mWebsocketUrl;
};


#endif // REGOVAR_H
