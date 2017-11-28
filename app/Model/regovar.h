#ifndef REGOVAR_H
#define REGOVAR_H

#include <QSettings>
//#include <QNetworkReply>
#include <QAuthenticator>
#include <QQmlApplicationEngine>

#include "framework/networkmanager.h"
#include "project/projectsmanager.h"
#include "subject/subjectsmanager.h"
#include "subject/samplesmanager.h"
#include "file/filesmanager.h"
#include "analysis/analysesmanager.h"
#include "tools/toolsmanager.h"
#include "subject/reference.h"
// TODO: rework as manager pattern
#include "user.h"
#include "admin.h"


#ifndef regovar
#define regovar (Regovar::i())
#endif



struct RegovarSettings
{
    int defaultReference = 0;
    QUrl serverUrl;
    QString localCacheDir;
    int localCacheMaxSize = 0;
};




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

    // Welcom
    Q_PROPERTY(QString searchRequest READ searchRequest WRITE setSearchRequest NOTIFY searchRequestChanged)
    Q_PROPERTY(QJsonObject searchResult READ searchResult NOTIFY searchResultChanged)
    Q_PROPERTY(bool searchInProgress READ searchInProgress NOTIFY searchInProgressChanged)
    Q_PROPERTY(QJsonArray lastAnalyses READ lastAnalyses NOTIFY lastDataChanged)
    Q_PROPERTY(QJsonArray lastEvent READ lastEvent NOTIFY lastDataChanged)
    Q_PROPERTY(QJsonArray lastSubjects READ lastSubjects NOTIFY lastDataChanged)
    Q_PROPERTY(bool welcomIsLoading READ welcomIsLoading WRITE setWelcomIsLoading NOTIFY welcomIsLoadingChanged)

    // Managers
    Q_PROPERTY(NetworkManager* networkManager READ networkManager NOTIFY neverChanged)
    Q_PROPERTY(ProjectsManager* projectsManager READ projectsManager NOTIFY neverChanged)
    Q_PROPERTY(SubjectsManager* subjectsManager READ subjectsManager NOTIFY neverChanged)
    Q_PROPERTY(SamplesManager* samplesManager READ samplesManager NOTIFY neverChanged)
    Q_PROPERTY(FilesManager* filesManager READ filesManager NOTIFY neverChanged)
    Q_PROPERTY(AnalysesManager* analysesManager READ analysesManager NOTIFY neverChanged)
    Q_PROPERTY(ToolsManager* toolsManager READ toolsManager NOTIFY neverChanged)

    // Others
    Q_PROPERTY(QList<QObject*> references READ references NOTIFY referencesChanged)
    Q_PROPERTY(User* user READ user NOTIFY userChanged)

    Q_PROPERTY(RegovarInfo* config READ config NOTIFY configChanged)
    Q_PROPERTY(Admin* admin READ admin NOTIFY adminChanged)
    Q_PROPERTY(QList<QObject*> openWindowModels READ openWindowModels NOTIFY neverChanged)

    // TODO: rework as Manager:
    //  - ConnectionManager (manage login, ServerStatus, pending queries, and websocket realtime event)
    //  - Configmanager ? (admin and settings)



public:


    static Regovar* i();
    void init();
    void readSettings();
    void writeSettings();

    // Getters
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
    inline NetworkManager* networkManager() const { return mNetworkManager; }
    inline ProjectsManager* projectsManager() const { return mProjectsManager; }
    inline SubjectsManager* subjectsManager() const { return mSubjectsManager; }
    inline SamplesManager* samplesManager() const { return mSamplesManager; }
    inline FilesManager* filesManager() const { return mFilesManager; }
    inline AnalysesManager* analysesManager() const { return mAnalysesManager; }
    inline ToolsManager* toolsManager() const { return mToolsManager; }
    //--
    inline QList<QObject*> references() const { return mReferences; }
    inline QList<QObject*> openWindowModels() const { return mOpenWindowModels; }

    // Setters
    inline void setSearchRequest(QString searchRequest) { mSearchRequest = searchRequest; emit searchRequestChanged(); }
    inline void setSearchResult(QJsonObject searchResult) { mSearchResult = searchResult; emit searchResultChanged(); }
    inline void setSearchInProgress(bool flag) { mSearchInProgress = flag; emit searchInProgressChanged(); }
    inline void setQmlEngine (QQmlApplicationEngine* engine) { mQmlEngine = engine; }
    inline void setWelcomIsLoading(bool flag) { mWelcomIsLoading=flag; emit welcomIsLoadingChanged(); }

    // Methods
    Reference* referenceFromId(int id);

    // Others
    Q_INVOKABLE void getVariantInfo(int refId, QString variantId, int analysisId=-1);
    Q_INVOKABLE void getGeneInfo(QString geneName, int analysisId=-1);
    Q_INVOKABLE void search(QString query);
    Q_INVOKABLE void loadWelcomData();
    Q_INVOKABLE void close();
    Q_INVOKABLE void disconnectUser();
    Q_INVOKABLE void quit();
    // Tools
    Q_INVOKABLE inline QUuid generateUuid() { return QUuid::createUuid(); }
    Q_INVOKABLE QString sizeToHumanReadable(qint64 size, qint64 uploadOffset=-1);
    Q_INVOKABLE void raiseError(QJsonObject raiseError);
    bool openNewWindow(QUrl qmlUrl, QObject* model);


public Q_SLOTS:
    void login(QString& login, QString& password);
    void logout();


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
    void variantInformationReady(QJsonObject json);

    void welcomIsLoadingChanged();
    void lastDataChanged();
    void referencesChanged();
    void configChanged();
    void adminChanged();
    void variantInformationReady(QJsonObject json);
    void geneInformationReady(QJsonObject json);

    void errorOccured(QString errCode, QString message, QString techData);
    void onClose();

private:
    // Singleton pattern
    Regovar();
    ~Regovar();
    static Regovar* mInstance;

    // Models
    //! wrap all settings retrieved from QSetting before initialisation of all managers
    RegovarSettings mSettings;
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



    //! Welcom last data
    QJsonArray mLastEvents;
    QJsonArray mLastAnalyses;
    QJsonArray mLastSubjects;

    //! List of open Filtering Analyses
    QList<FilteringAnalysis*> mOpenAnalyses;



    //! list of references supported by the server
    QList<QObject*> mReferences;
    int mReferenceDefault = -1;

    // Managers
    //! Manage network (all requests Up/Down with the server, authent, and websocket connection)
    NetworkManager* mNetworkManager = nullptr;
    //! Manage projects (Browse + CRUD)
    ProjectsManager* mProjectsManager = nullptr;
    //! Manage subjects (Browse + CRUD)
    SubjectsManager* mSubjectsManager = nullptr;
    //! Browse all samples available on the server
    SamplesManager* mSamplesManager = nullptr;
    //! Browse&Upload files
    FilesManager* mFilesManager = nullptr;
    //! Manage analyses
    AnalysesManager* mAnalysesManager = nullptr;
    //! Custom Tools managers (exporters, reporters)
    ToolsManager* mToolsManager = nullptr;
    // PipelinesManangers


    // Technical stuff
    //! We need ref to the QML engine to create/open new windows for Analysis
    QQmlApplicationEngine* mQmlEngine = nullptr;


    //! List of model used by additional qml windows open
    QList<QObject*> mOpenWindowModels;
};


#endif // REGOVAR_H
