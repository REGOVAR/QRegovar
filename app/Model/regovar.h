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
#include "Model/analysis/pipeline/pipelineanalysis.h"

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
    // Welcom
    Q_PROPERTY(QString searchRequest READ searchRequest WRITE setSearchRequest NOTIFY searchRequestChanged)
    Q_PROPERTY(QJsonObject searchResult READ searchResult NOTIFY searchResultChanged)
    Q_PROPERTY(bool searchInProgress READ searchInProgress NOTIFY searchInProgressChanged)
    Q_PROPERTY(QJsonArray lastAnalyses READ lastAnalyses NOTIFY lastAnalysesChanged)
    Q_PROPERTY(QJsonArray lastEvent READ lastEvent NOTIFY lastEventChanged)
    Q_PROPERTY(QJsonArray lastSubjects READ lastSubjects NOTIFY lastSubjectsChanged)

    // Browsers
    Q_PROPERTY(ProjectsTreeModel* projectsTreeView READ projectsTreeView NOTIFY projectsTreeViewChanged)
    Q_PROPERTY(QList<QObject*> projectsOpen READ projectsOpen NOTIFY projectsOpenChanged)
    Q_PROPERTY(QVariantList subjetsOpen READ subjetsOpen NOTIFY subjetsOpenChanged)

    // New analysis wizard
    Q_PROPERTY(QList<QObject*> references READ references NOTIFY referencesChanged)
    Q_PROPERTY(QList<QObject*> projects READ projectsList NOTIFY projectsListChanged)
    Q_PROPERTY(QList<QObject*> remoteFilesList READ remoteFilesList NOTIFY remoteFilesListChanged)
    Q_PROPERTY(QList<QObject*> remoteSamplesList READ remoteSamplesList NOTIFY remoteSamplesListChanged)
    Q_PROPERTY(PipelineAnalysis* newPipelineAnalysis READ newPipelineAnalysis NOTIFY newPipelineAnalysisChanged)
    Q_PROPERTY(FilteringAnalysis* newFilteringAnalysis READ newFilteringAnalysis NOTIFY newFilteringAnalysisChanged)

    //
    Q_PROPERTY(Project* currentProject READ currentProject NOTIFY currentProjectChanged)


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
    inline QList<QObject*> remoteFilesList() const { return mRemoteFilesList; }
    inline QList<QObject*> remoteSamplesList() const { return mRemoteSamplesList; }
    inline Project* currentProject() const { return mCurrentProject; }
    inline QJsonArray lastAnalyses() const { return mLastAnalyses; }
    inline QJsonArray lastEvent() const { return mLastEvents; }
    inline QJsonArray lastSubjects() const { return mLastSubjects; }
    inline QList<QObject*> projectsOpen() const { return mProjectsOpen; }
    inline QVariantList subjetsOpen() const { return mSubjectsOpen; }
    //inline UserModel* currentUser() const { return mUser; }
    inline PipelineAnalysis* newPipelineAnalysis() const { return mNewPipelineAnalysis; }
    inline FilteringAnalysis* newFilteringAnalysis() const { return mNewFilteringAnalysis; }
    inline QList<QObject*> references() const { return mReferences; }

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
    Q_INVOKABLE void enqueueUploadFile(QStringList filesPaths);
    Q_INVOKABLE void raiseError(QJsonObject raiseError);
    Q_INVOKABLE void close();
    Q_INVOKABLE void disconnectUser();
    Q_INVOKABLE void quit();
    Q_INVOKABLE void openAnalysis(int analysisId);
    Q_INVOKABLE FilteringAnalysis* getAnalysisFromWindowId(int winId);
    Q_INVOKABLE void search(QString query);
    Q_INVOKABLE void getWelcomLastData();
    Q_INVOKABLE void resetNewAnalysisWizardModels();


    Q_INVOKABLE void loadFilesBrowser();
    Q_INVOKABLE void loadSampleBrowser(int refId);


public Q_SLOTS:
//    void login(QString& login, QString& password);
//    void logout();
    void onAuthenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);

    void refreshProjectsTreeView();
    void filesEnqueued(QHash<QString,QString> mapping);

    void loadProject(int id);
    void loadAnalysis(int id);

    // Websocket
    void onWebsocketConnected();
    void onWebsocketClosed();
    void onWebsocketReceived(QString message);


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
    void remoteFilesListChanged();
    void remoteSamplesListChanged();
    void currentProjectChanged();
    void referencesChanged();
    void onClose();
    void onError(QString errCode, QString message);
    void projectCreationDone(bool success, int projectId);
    void analysisCreationDone(bool success, int analysisId);
    void subjectCreationDone(bool success, int subjectId);
    void lastAnalysesChanged();
    void lastEventChanged();
    void lastSubjectsChanged();
    void subjetsOpenChanged();
    void projectsOpenChanged();
    void newPipelineAnalysisChanged();
    void newFilteringAnalysisChanged();
    void websocketMessageReceived(QString action, QJsonObject data);
    void projectsListChanged();

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
    QList<QObject*> mRemoteFilesList;
    //! The model used to browse all samples available on the server
    QList<QObject*> mRemoteSamplesList;
    //! The uploader that manage TUS protocol (resumable upload)
    TusUploader * mUploader;
    //! Filtering analyses
    QList<FilteringAnalysis*> mOpenAnalyses;
    //! Welcom last data
    QJsonArray mLastEvents;
    QJsonArray mLastAnalyses;
    QJsonArray mLastSubjects;
    //! list of references supported by the server
    QList<QObject*> mReferences;
    int mReferenceDefault;
    //! list of project/subject open
    QList<QObject*> mProjectsOpen;
    QVariantList mSubjectsOpen;
    //! model to hold data when using form to create a new analysis
    PipelineAnalysis* mNewPipelineAnalysis;
    FilteringAnalysis* mNewFilteringAnalysis;

    //! We need ref to the QML engine to create/open new windows for Analysis
    QQmlApplicationEngine* mQmlEngine;

    //! Websocket
    QWebSocket mWebSocket;
    QUrl mWebsocketUrl;
};


#endif // REGOVAR_H
