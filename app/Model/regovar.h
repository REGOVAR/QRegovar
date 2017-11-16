#ifndef REGOVAR_H
#define REGOVAR_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include <QQmlApplicationEngine>
#include <QtWebSockets/QtWebSockets>

#include "analysis/filtering/filteringanalysis.h"
#include "analysis/pipeline/pipelineanalysis.h"
#include "subject/subjectsmanager.h"
#include "subject/samplesmanager.h"
#include "file/filesmanager.h"
// TODO: rework as manager pattern
#include "user.h"
#include "admin.h"
#include "project/projectstreemodel.h"
#include "project/project.h"

#ifndef regovar
#define regovar (Regovar::i())
#endif

class FilteringAnalysis;


class RegovarInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString serverVersion READ serverVersion NOTIFY configChanged)
    Q_PROPERTY(QString clientVersion READ clientVersion NOTIFY configChanged)
    Q_PROPERTY(QString website READ website NOTIFY configChanged)
    Q_PROPERTY(QString license READ license  NOTIFY configChanged)
    Q_PROPERTY(QJsonObject release READ release  NOTIFY configChanged)

public:
    explicit RegovarInfo(QObject *parent = nullptr);
    // Getters
    inline QString serverVersion() { return mServerVersion; }
    inline QString clientVersion() { return mClientVersion; }
    inline QString website() { return mWebsite; }
    inline QString license() { return mLicense; }
    inline QJsonObject release() { return mRelease; }
    // Setters
    inline void setRelease(QJsonObject release) { mRelease = release; emit configChanged(); }
    // Methods
    void fromJson(QJsonObject json);

Q_SIGNALS:
    void configChanged();

private:
    QString mServerVersion;
    QString mClientVersion;
    QString mWebsite;
    QString mLicense;
    QJsonObject mRelease;
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
    Q_PROPERTY(RegovarInfo* config READ config NOTIFY configChanged)
    Q_PROPERTY(Admin* admin READ admin NOTIFY adminChanged)
    // Welcom
    Q_PROPERTY(User* user READ user NOTIFY userChanged)
    Q_PROPERTY(QString searchRequest READ searchRequest WRITE setSearchRequest NOTIFY searchRequestChanged)
    Q_PROPERTY(QJsonObject searchResult READ searchResult NOTIFY searchResultChanged)
    Q_PROPERTY(bool searchInProgress READ searchInProgress NOTIFY searchInProgressChanged)
    Q_PROPERTY(QJsonArray lastAnalyses READ lastAnalyses NOTIFY lastDataChanged)
    Q_PROPERTY(QJsonArray lastEvent READ lastEvent NOTIFY lastDataChanged)
    Q_PROPERTY(QJsonArray lastSubjects READ lastSubjects NOTIFY lastDataChanged)
    Q_PROPERTY(bool welcomIsLoading READ welcomIsLoading WRITE setWelcomIsLoading NOTIFY welcomIsLoadingChanged)

    // Browsers
    Q_PROPERTY(ProjectsTreeModel* projectsTreeView READ projectsTreeView NOTIFY projectsTreeViewChanged)
    Q_PROPERTY(QList<QObject*> projectsOpen READ projectsOpen NOTIFY projectsOpenChanged)

    Q_PROPERTY(FilesManager* filesManager READ filesManager NOTIFY neverChanged)
    Q_PROPERTY(SubjectsManager* subjectsManager READ subjectsManager NOTIFY neverChanged)
    Q_PROPERTY(SamplesManager* samplesManager READ samplesManager NOTIFY neverChanged)

    // New analysis wizard
    Q_PROPERTY(QList<QObject*> references READ references NOTIFY referencesChanged)


    Q_PROPERTY(QList<QObject*> projects READ projectsList NOTIFY projectsListChanged)
    Q_PROPERTY(int selectedProject READ selectedProject WRITE setSelectedProject NOTIFY selectedProjectChanged)
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

    // Getters
    inline ServerStatus connectionStatus() { return mConnectionStatus; }
    inline QUrl& serverUrl() { return mApiRootUrl; }
    inline RegovarInfo* config() const { return mConfig; }
    inline Admin* admin() { return mAdmin; }
    //--
    inline User* user() const { return mUser; }
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
    inline FilesManager* filesManager() const { return mFilesManager; }
    inline SubjectsManager* subjectsManager() const { return mSubjectsManager; }
    inline SamplesManager* samplesManager() const { return mSamplesManager; }
    //--
    inline QList<QObject*> references() const { return mReferences; }
    inline QList<QObject*> projectsList() const { return mProjectsList; }
    inline int selectedProject() const { return mSelectedProject; }
    inline PipelineAnalysis* newPipelineAnalysis() const { return mNewPipelineAnalysis; }
    inline FilteringAnalysis* newFilteringAnalysis() const { return mNewFilteringAnalysis; }

    // Setters
    inline void setServerUrl(QUrl newUrl) { mApiRootUrl = newUrl; emit serverUrlChanged(); }
    inline void setConnectionStatus(ServerStatus flag) { mConnectionStatus = flag; emit connectionStatusChanged(); }
    inline void setSearchRequest(QString searchRequest) { mSearchRequest = searchRequest; emit searchRequestChanged(); }
    inline void setSearchResult(QJsonObject searchResult) { mSearchResult = searchResult; emit searchResultChanged(); }
    inline void setSearchInProgress(bool flag) { mSearchInProgress = flag; emit searchInProgressChanged(); }
    inline void setQmlEngine (QQmlApplicationEngine* engine) { mQmlEngine = engine; }
    inline void setWelcomIsLoading(bool flag) { mWelcomIsLoading=flag; emit welcomIsLoadingChanged(); }
    void setSelectedProject(int idx);

    // Methods
    // Project management
    Q_INVOKABLE void newProject(QString name, QString comment);
    Q_INVOKABLE void openProject(int id);
    Q_INVOKABLE void openProject(QJsonObject json);
    void refreshProjectsLists();
    void refreshFlatProjectsListRecursive(QJsonArray data, QString prefix);

    // Analysis management
    Q_INVOKABLE bool newAnalysis(QString type);
    Q_INVOKABLE void resetNewFilteringAnalysisWizard(int refId);
    Q_INVOKABLE void resetNewPipelinAnalysisWizard();
    Q_INVOKABLE FilteringAnalysis* getAnalysisFromWindowId(int winId);
    Reference* referenceFromId(int id);
    // File management

    // Others
    Q_INVOKABLE void getVariantInfo(int refId, QString variantId, int analysisId=-1);
    Q_INVOKABLE void search(QString query);
    Q_INVOKABLE void loadWelcomData();
    Q_INVOKABLE void close();
    Q_INVOKABLE void disconnectUser();
    Q_INVOKABLE void quit();
    // Tools
    Q_INVOKABLE inline QUuid generateUuid() { return QUuid::createUuid(); }
    Q_INVOKABLE QString sizeToHumanReadable(qint64 size, qint64 uploadOffset=-1);
    Q_INVOKABLE void raiseError(QJsonObject raiseError);



public Q_SLOTS:
    void login(QString& login, QString& password);
    void logout();
    void onAuthenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);

    void refreshProjectsTreeView();

    void openAnalysis(int id);
    bool openAnalysis(QJsonObject data);

    // Websocket
    void onWebsocketConnected();
    void onWebsocketClosed();
    void onWebsocketError(QAbstractSocket::SocketError error);
    void onWebsocketStateChanged(QAbstractSocket::SocketState state);
    void onWebsocketReceived(QString message);


Q_SIGNALS:
    //! special signal used for QML property that never changed to avoid to declare to many useless signal
    //! QML need that property declare a "changed" event for binding
    void neverChanged();

    void userChanged();
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();
    void searchRequestChanged();
    void searchResultChanged();
    void searchInProgressChanged();
    void serverUrlChanged();
    void projectsTreeViewChanged();
    void referencesChanged();
    void onClose();
    void errorOccured(QString errCode, QString message, QString techData);
    void projectCreationDone(bool success, int projectId);
    void analysisCreationDone(bool success, int analysisId);
    void lastDataChanged();
    void subjectsOpenChanged();
    void projectsOpenChanged();
    void newPipelineAnalysisChanged();
    void newFilteringAnalysisChanged();
    void websocketMessageReceived(QString action, QJsonObject data);
    void projectsListChanged();
    void welcomIsLoadingChanged();
    void selectedProjectChanged();
    void connectionStatusChanged();
    void configChanged();
    void adminChanged();
    void variantInformationReady(QJsonObject json);

private:
    // Singleton pattern
    Regovar();
    ~Regovar();
    static Regovar* mInstance;

    // Models
    //! The root url to the server api
    QUrl mApiRootUrl;
    //! Server connection status
    ServerStatus mConnectionStatus;
    //! The config retrieved from the server
    RegovarInfo* mConfig = nullptr;
    //! The current user of the application
    User* mUser = nullptr;
    //! Admin operation wrapper
    Admin* mAdmin = nullptr;

    //! Search request and results
    QString mSearchRequest;
    QJsonObject mSearchResult;
    bool mSearchInProgress = false;
    bool mWelcomIsLoading = false;

    //! The flat list of project (use for project's combobox selection)
    QList<QObject*> mProjectsList;
    int mSelectedProject;


    //! Welcom last data
    QJsonArray mLastEvents;
    QJsonArray mLastAnalyses;
    QJsonArray mLastSubjects;

    //! List of open Filtering Analyses
    QList<FilteringAnalysis*> mOpenAnalyses;



    // Creation Wizards Models
    //! model to hold data when using form to create a new analysis
    PipelineAnalysis* mNewPipelineAnalysis = nullptr;
    FilteringAnalysis* mNewFilteringAnalysis = nullptr;
    //! list of references supported by the server
    QList<QObject*> mReferences;
    int mReferenceDefault;

    // Managers
    //! Manage subjects (Browse + CRUD)
    SubjectsManager* mSubjectsManager = nullptr;
    //! Browse all samples available on the server
    SamplesManager* mSamplesManager = nullptr;
    //! Browse&Upload files
    FilesManager* mFilesManager = nullptr;
    // ProjectsManager
    //! The model of the projects browser treeview
    ProjectsTreeModel* mProjectsTreeView = nullptr;
    //! list of project/subject open
    QList<QObject*> mProjectsOpen;
    // FilesManager

    // PipelinesManangers


    // Technical stuff
    //! We need ref to the QML engine to create/open new windows for Analysis
    QQmlApplicationEngine* mQmlEngine = nullptr;
    //! Websocket
    QWebSocket mWebSocket;
    QUrl mWebsocketUrl;
    QStringList mWsFilesActionsList = {"file_upload"};
    QStringList mWsSamplesActionsList = {"import_vcf_processing"};
    QStringList mWsFilteringActionsList = {"analysis_computing"};
    QStringList mWsPipelinesActionsList = {"pipeline_install", "pipeline_uninstall"};
    QStringList mWsJobsActionsList = {"job_"};
};


#endif // REGOVAR_H
