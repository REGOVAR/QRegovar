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


class RegovarConfig: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString serverVersion READ serverVersion NOTIFY configChanged)
    Q_PROPERTY(QString clientVersion READ clientVersion NOTIFY configChanged)
    Q_PROPERTY(QString website READ website NOTIFY configChanged)
    Q_PROPERTY(QString license READ license  NOTIFY configChanged)

public:
    explicit RegovarConfig(QObject *parent = nullptr);
    // Getters
    inline QString serverVersion() { return mServerVersion; }
    inline QString clientVersion() { return mClientVersion; }
    inline QString website() { return mWebsite; }
    inline QString license() { return mLicense; }
    // Setters
    void fromJson(QJsonObject json);
Q_SIGNALS:
    void configChanged();

private:
    QString mServerVersion;
    QString mClientVersion;
    QString mWebsite;
    QString mLicense;
};



/*!
 * \brief Singleton.
 * Main Regovar's client core. Wrap models and manage all interaction with the server
 * (websocket, rest api, tus resumable upload, and so on.
 */
class Regovar : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl serverUrl READ serverUrl WRITE setServerUrl NOTIFY serverUrlChanged)
    Q_PROPERTY(ServerStatus connectionStatus READ connectionStatus WRITE setConnectionStatus NOTIFY connectionStatusChanged)
    Q_PROPERTY(RegovarConfig* config READ config)
    // Welcom
    Q_PROPERTY(QString searchRequest READ searchRequest WRITE setSearchRequest NOTIFY searchRequestChanged)
    Q_PROPERTY(QJsonObject searchResult READ searchResult NOTIFY searchResultChanged)
    Q_PROPERTY(bool searchInProgress READ searchInProgress NOTIFY searchInProgressChanged)
    Q_PROPERTY(QJsonArray lastAnalyses READ lastAnalyses NOTIFY lastAnalysesChanged)
    Q_PROPERTY(QJsonArray lastEvent READ lastEvent NOTIFY lastEventChanged)
    Q_PROPERTY(QJsonArray lastSubjects READ lastSubjects NOTIFY lastSubjectsChanged)
    Q_PROPERTY(bool welcomIsLoading READ welcomIsLoading WRITE setWelcomIsLoading NOTIFY welcomIsLoadingChanged)

    // Browsers
    Q_PROPERTY(ProjectsTreeModel* projectsTreeView READ projectsTreeView NOTIFY projectsTreeViewChanged)
    Q_PROPERTY(QList<QObject*> projectsOpen READ projectsOpen NOTIFY projectsOpenChanged)
    Q_PROPERTY(QVariantList subjetsOpen READ subjetsOpen NOTIFY subjetsOpenChanged)

    // New analysis wizard
    Q_PROPERTY(QList<QObject*> references READ references NOTIFY referencesChanged)
    Q_PROPERTY(int selectedReference READ selectedReference WRITE setSelectedReference NOTIFY selectedReferenceChanged)
    Q_PROPERTY(QList<QObject*> projects READ projectsList NOTIFY projectsListChanged)
    Q_PROPERTY(int selectedProject READ selectedProject WRITE setSelectedProject NOTIFY selectedProjectChanged)
    Q_PROPERTY(QList<QObject*> remoteFilesList READ remoteFilesList NOTIFY remoteFilesListChanged)
    Q_PROPERTY(QList<QObject*> remoteSamplesList READ remoteSamplesList NOTIFY remoteSamplesListChanged)
    Q_PROPERTY(PipelineAnalysis* newPipelineAnalysis READ newPipelineAnalysis NOTIFY newPipelineAnalysisChanged)
    Q_PROPERTY(FilteringAnalysis* newFilteringAnalysis READ newFilteringAnalysis NOTIFY newFilteringAnalysisChanged)



public:
    enum ServerStatus
    {
        // Connected to the sever.
        ready=0,
        // Connection refused : user need to login
        accessDenied,
        // Server is in error : returned HTTP 500
        error,
        // Not eable to reach the server : are url/proxy settings good ? Is the server on ?
        unreachable
    };
    Q_ENUMS(ServerStatus)

    static Regovar* i();
    void init();
    void readSettings();
    void writeSettings();

    // Accessors
    inline ServerStatus connectionStatus() { return mConnectionStatus; }
    inline QUrl& serverUrl() { return mApiRootUrl; }
    inline RegovarConfig* config() const { return mConfig; }
    //--
    inline QString searchRequest() { return mSearchRequest; }
    inline QJsonObject searchResult() const { return mSearchResult; }
    inline bool searchInProgress() const { return mSearchInProgress; }
    inline QJsonArray lastAnalyses() const { return mLastAnalyses; }
    inline QJsonArray lastEvent() const { return mLastEvents; }
    inline QJsonArray lastSubjects() const { return mLastSubjects; }
    inline bool welcomIsLoading() const { return mWelcomIsLoading; }
    //--
    inline ProjectsTreeModel* projectsTreeView() const { return mProjectsTreeView; }
    inline QList<QObject*> projectsOpen() const { return mProjectsOpen; }
    inline QVariantList subjetsOpen() const { return mSubjectsOpen; }
    //--
    inline QList<QObject*> references() const { return mReferences; }
    inline int selectedReference() const { return mSelectedReference; }
    inline QList<QObject*> projectsList() const { return mProjectsList; }
    inline int selectedProject() const { return mSelectedProject; }
    inline QList<QObject*> remoteFilesList() const { return mRemoteFilesList; }
    inline QList<QObject*> remoteSamplesList() const { return mRemoteSamplesList; }
    inline PipelineAnalysis* newPipelineAnalysis() const { return mNewPipelineAnalysis; }
    inline FilteringAnalysis* newFilteringAnalysis() const { return mNewFilteringAnalysis; }
    //--
    //inline UserModel* currentUser() const { return mUser; }

    // Setters
    inline void setServerUrl(QUrl newUrl) { mApiRootUrl = newUrl; emit serverUrlChanged(); }
    inline void setConnectionStatus(ServerStatus flag) { mConnectionStatus = flag; emit connectionStatusChanged(); }
    inline void setSearchRequest(QString searchRequest) { mSearchRequest = searchRequest; emit searchRequestChanged(); }
    inline void setSearchResult(QJsonObject searchResult) { mSearchResult = searchResult; emit searchResultChanged(); }
    inline void setSearchInProgress(bool flag) { mSearchInProgress = flag; emit searchInProgressChanged(); }
    inline void setQmlEngine (QQmlApplicationEngine* engine) { mQmlEngine = engine; }
    inline void setWelcomIsLoading(bool flag) { mWelcomIsLoading=flag; emit welcomIsLoadingChanged(); }
    void setSelectedReference(int idx);
    void setSelectedProject(int idx);

    // Methods
    Q_INVOKABLE void newProject(QString name, QString comment);
    Q_INVOKABLE bool newAnalysis(QString type);
    Q_INVOKABLE void newSubject(QJsonObject data);
    Q_INVOKABLE void enqueueUploadFile(QStringList filesPaths);
    Q_INVOKABLE void raiseError(QJsonObject raiseError);
    Q_INVOKABLE void close();
    Q_INVOKABLE void disconnectUser();
    Q_INVOKABLE void quit();
    Q_INVOKABLE FilteringAnalysis* getAnalysisFromWindowId(int winId);
    Q_INVOKABLE void search(QString query);
    Q_INVOKABLE void resetNewAnalysisWizardModels();
    Q_INVOKABLE void openProject(QJsonObject json);
    Q_INVOKABLE void openProject(int id);
    Reference* referencesFromId(int id);

    Q_INVOKABLE void loadWelcomData();
    Q_INVOKABLE void loadFilesBrowser();
    Q_INVOKABLE void loadSampleBrowser(int refId);
    Q_INVOKABLE inline QUuid generateUuid() { return QUuid::createUuid(); }
    void initFlatProjectList();
    void initFlatProjectListRecursive(QJsonArray data, QString prefix);


public Q_SLOTS:
//    void login(QString& login, QString& password);
//    void logout();
    void onAuthenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);

    void refreshProjectsTreeView();
    void filesEnqueued(QHash<QString,QString> mapping);

    void openAnalysis(int id);
    bool openAnalysis(QJsonObject data);

    // Websocket
    void onWebsocketConnected();
    void onWebsocketClosed();
    void onWebsocketError(QAbstractSocket::SocketError error);
    void onWebsocketStateChanged(QAbstractSocket::SocketState state);
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
    void referencesChanged();
    void onClose();
    void errorOccured(QString errCode, QString message, QString techData);
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
    void welcomIsLoadingChanged();
    void selectedReferenceChanged();
    void selectedProjectChanged();
    void connectionStatusChanged();

private:
    Regovar();
    ~Regovar();
    static Regovar* mInstance;

    // Models
    //! The root url to the server api
    QUrl mApiRootUrl;
    //! Server connection status
    ServerStatus mConnectionStatus;
    //! The config retrieved from the server
    RegovarConfig* mConfig;
    //! The current user of the application
    // UserModel * mUser;
    //! Search request and results
    QString mSearchRequest;
    QJsonObject mSearchResult;
    bool mSearchInProgress = false;
    bool mWelcomIsLoading = false;

    //! The model of the projects browser treeview
    ProjectsTreeModel* mProjectsTreeView;
    //! The flat list of project (use for project's combobox selection)
    QList<QObject*> mProjectsList;
    int mSelectedProject;
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
    int mSelectedReference;
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
