#include <QQmlContext>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQmlComponent>
#include <QAbstractSocket>
#include <QSysInfo>
#include "regovar.h"
#include "framework/request.h"
#include "file/file.h"
#include "subject/reference.h"
#include "subject/sample.h"
#include "tools/tool.h"
#include <QDateTime>
#include <QApplication>
#include <QTimer>
#include <QLocale>

#include "Model/analysis/filtering/filteringanalysis.h"
#include "Model/event/event.h"


Regovar* Regovar::mInstance = Q_NULLPTR;
Regovar* Regovar::i()
{
    if (mInstance == Q_NULLPTR)
    {
        mInstance = new Regovar();
    }
    return mInstance;
}

Regovar::Regovar() {}
Regovar::~Regovar() {}



void Regovar::init()
{
    // Load settings
    mSettings = new Settings();

    // Create models
    mConfig = new RegovarInfo();
    mAdmin = new Admin();
    mMainMenu = new RootMenu(this);
    mMainMenu->initMain();

    // Init network manager
    mNetworkManager = new NetworkManager(this);
    mNetworkManager->setServerUrl(mSettings->serverUrl());
    mNetworkManager->setSharedUrl(mSettings->sharedUrl());

    // Init file manager
    mFilesManager = new FilesManager(this);
    mFilesManager->setCacheDir(mSettings->localCacheDir());
    mFilesManager->setCacheMaxSize(mSettings->localCacheMaxSize());

    // Init user manager and current user if autologin enabled
    mUsersManager = new UsersManager(this);

    // Init others managers
    mProjectsManager = new ProjectsManager(this);
    mSubjectsManager = new SubjectsManager(this);
    mSamplesManager = new SamplesManager(mSettings->defaultReference());
    mAnalysesManager = new AnalysesManager(this);
    mPanelsManager = new PanelsManager(this);
    mPhenotypesManager = new PhenotypesManager(this);
    mEventsManager = new EventsManager(this);
    mToolsManager = new ToolsManager(this);
    mPipelinesManager = new PipelinesManager(this);

    // Load misc data
    mLastAnalyses = new AnalysesListModel(this);
    mLastSubjects = new SubjectsListModel(this);

    loadConfigData();
    // Auto log last user ?
    if (mSettings->keepMeLogged())
    {
        // Restore cookie and try to authent with it
        mUsersManager->login();
    }
    else
    {
        regovar->mainMenu()->goTo(0,0,0);
        emit mUsersManager->logoutSuccess();
        emit mUsersManager->displayLoginScreen(true);
    }
}






void Regovar::loadConfigData()
{
    setWelcomIsLoading(true);
    Request* req = Request::get(QString("/config"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();

            // Get server config and release information
            mConfig->loadJson(data);
            QJsonObject milestones;
            for (const QJsonValue& val: data["client_milestones"].toArray())
            {
                milestones = val.toObject();
                if (milestones["state"].toString() == "open")
                {
                    if (mConfig->release().isEmpty() || mConfig->release()["due_on"].toString() > milestones["due_on"].toString())
                    {
                        double progress = milestones["closed_issues"].toDouble() / (milestones["open_issues"].toDouble() + milestones["closed_issues"].toDouble());
                        milestones.insert("progress", progress);
                        milestones.insert("success", true);
                        mConfig->setRelease(milestones);
                    }
                }
            }
            if (milestones.isEmpty())
            {
                milestones.insert("success", false);
                milestones.insert("html_url", "https://github.com/REGOVAR/QRegovar/milestones");
                mConfig->setRelease(milestones);
            }

            // Get files import/export tools available on Regovar server
            mToolsManager->loadJson(data["tools"].toObject());
            emit configChanged();
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
        setWelcomIsLoading(true);
    });
}


void Regovar::loadWelcomData()
{
    setWelcomIsLoading(true);
    Request* req = Request::get(QString("/"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();

            // Get references
            for (const QJsonValue& jsonVal: data["references"].toArray())
            {
                QJsonObject refD = jsonVal.toObject();
                int id = refD["id"].toInt();
                Reference* ref = referenceFromId(id);
                if (ref == nullptr)
                {
                    ref = new Reference(this);
                    ref->loadJson(jsonVal.toObject());
                    if (ref->id() > 0) mReferences.append(ref);
                }
            }

            // Get users
            mUsersManager->loadJson(data["users"].toArray());

            // Get panels
            mPanelsManager->loadJson(data["panels"].toArray());

            // Get pipelines
            mPipelinesManager->loadJson(data["pipelines"].toArray());

            // Get samples
            mSamplesManager->loadJson(data["samples"].toArray());

            // Get subjects (Must be loaded after samples and before last_subjects)
            mSubjectsManager->loadJson(data["subjects"].toArray());

            // Get analyses
            mAnalysesManager->loadJson(data["analyses"].toArray());

            // Gets jobs
            mAnalysesManager->loadJson(data["jobs"].toArray());

            // Get projects (must be load after analyses + jobs)
            mProjectsManager->loadJson(data["projects"].toArray());

            // Last analyses
            mLastAnalyses->clear();
            for (const QJsonValue& val: data["last_analyses"].toArray())
            {

                QJsonObject ajson = val.toObject();
                Analysis* a = nullptr;
                if (ajson["type"] == "analysis")
                {
                   a = (Analysis*) mAnalysesManager->getOrCreateFilteringAnalysis(ajson["id"].toInt());
                }
                else if (ajson["type"] == "pipeline")
                {
                    a = (Analysis*) mAnalysesManager->getOrCreatePipelineAnalysis(ajson["id"].toInt());
                }
                if (a != nullptr)
                {
                    mLastAnalyses->append(a);
                }
            }
            // Last subjects
            mLastSubjects->clear();
            for (const QJsonValue& val: data["last_subjects"].toArray())
            {
                Subject* sbj = mSubjectsManager->getOrCreateSubject(val.toInt());
                mLastSubjects->append(sbj);
            }
            // Last events
            mEventsManager->loadJson(data["last_events"].toArray());

            emit lastDataChanged();
            emit referencesChanged();
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
        setWelcomIsLoading(true);
    });
}



bool Regovar::openNewWindow(QUrl qmlUrl, QObject* model)
{
    // Build unique windows id according to the model
    QString wid = "unique_wid";
    if (model != nullptr)
    {
        wid = model->metaObject()->className();
    }

    if (wid == "FilteringAnalysis" || wid == "PipelineAnalysis")
    {
        wid += "_" + QString::number(qobject_cast<Analysis*>(model)->id());
    }
    else if (wid == "Disease" || wid == "Phenotype")
    {
        wid += "_" + qobject_cast<HpoData*>(model)->id();
    }
    else if (wid == "Panel")
    {
        wid += "_" + qobject_cast<Panel*>(model)->id();
    }
    return openNewWindow(qmlUrl, model, wid);
}

bool Regovar::openNewWindow(QUrl qmlUrl, QObject* model, QString wid)
{

    qDebug() << "OPEN WINDOW ID:" << wid;

    // Store model of the new windows in a collection readable from qml
    if (mOpenWindowModels.contains(wid))
    {
        // TODO: window already open, set focus on it
    }

    // Create new window
    mOpenWindowModels.insert(wid, model);

    // Create new QML window
    QQmlComponent *c = new QQmlComponent(mQmlEngine, qmlUrl, QQmlComponent::PreferSynchronous);
    if (c->isReady())
    {
        QObject* o = c->create(mQmlEngine->rootContext());
        QQuickWindow *i = qobject_cast<QQuickWindow*>(o);
        QQmlEngine::setObjectOwnership(i, QQmlEngine::CppOwnership);

        // Call init qml method to retrieve its model
        QMetaObject::invokeMethod(i, "initFromCpp", Q_ARG(QVariant, wid));

        // Setup qml window's parent
        QObject* root = mQmlEngine->rootObjects()[0];
        QQuickWindow* rootWin = qobject_cast<QQuickWindow*>(root);
        if (!rootWin)
        {
            qFatal("Error: Your root item has to be a window.");
            return false;
        }
        i->setParent(0);
        i->setVisible(true);
    }
    else
    {
        emit errorOccured("", tr("Enable to create new QML windows"), c->errorString());
        return false;
    }


    return true;
}

bool Regovar::closeWindow(QString wid)
{
    if (mOpenWindowModels.contains(wid))
    {
        mOpenWindowModels.remove(wid);
        return true;
    }
    return false;
}


Reference* Regovar::referenceFromId(int id)
{
    for (QObject* o: mReferences)
    {
        Reference* ref = qobject_cast<Reference*>(o);
        if (ref->id()==id)
        {
            return ref;
        }
    }
    return nullptr;
}



//void Regovar::setSelectedReference(int idx)
//{
//    mSelectedReference=idx;
//    Reference* ref = qobject_cast<Reference*>(mReferences[idx]);
//    mnewFiltering->setReference(ref, false);
//    mSamplesManager->setReferencialId(ref->id());
//    emit selectedReferenceChanged();
//}



















void Regovar::getFileInfo(int fileId)
{
    File* file = mFilesManager->getOrCreateFile(fileId);
    openNewWindow(QUrl("qrc:/qml/Windows/FileInfoWindow.qml"), file);
    file->load(false);
    emit fileInformationReady(file);
}


void Regovar::getPanelInfo(QString panelId)
{
    Panel* panel = mPanelsManager->getOrCreatePanel(panelId);
    openNewWindow(QUrl("qrc:/qml/Windows/PanelInfoWindow.qml"), panel);
    panel->load(false);
    emit panelInformationReady(panel);
}


void Regovar::getSampleInfo(int sampleId)
{
    Sample* sample = mSamplesManager->getOrCreateSample(sampleId);
    sample->load(false);
    openNewWindow(QUrl("qrc:/qml/Windows/SampleInfoWindow.qml"), sample);
    emit sampleInformationReady(sample);
}


void Regovar::getUserInfo(int userId)
{
    User* user= mUsersManager->getOrCreateUser(userId);
    openNewWindow(QUrl("qrc:/qml/Windows/UserInfoWindow.qml"), user);
    user->load(false);
    emit userInformationReady(user);
}


void Regovar::getPipelineInfo(int pipelineId)
{
    Pipeline* pipeline = pipelinesManager()->getOrCreatePipe(pipelineId);
    openNewWindow(QUrl("qrc:/qml/Windows/PipelineInfoWindow.qml"), pipeline);
    pipeline->load(false);
    emit pipelineInformationReady(pipeline);
}


void Regovar::getGeneInfo(QString symbol, int)
{
    Gene* gene = phenotypesManager()->getGene(symbol);
    gene->load();
    openNewWindow(QUrl("qrc:/qml/Windows/GeneInfoWindow.qml"), gene);
    emit geneInformationReady(gene);
}


void Regovar::getPhenotypeInfo(QString phenotypeId)
{
    HpoData* hpo = phenotypesManager()->getOrCreate(phenotypeId);
    hpo->load(false);
    if (phenotypeId.startsWith("HP:"))
    {
        openNewWindow(QUrl("qrc:/qml/Windows/PhenotypeInfoWindow.qml"), hpo);
        emit phenotypeInformationReady((Phenotype*)hpo);
    }
    else
    {
        openNewWindow(QUrl("qrc:/qml/Windows/DiseaseInfoWindow.qml"), hpo);
        emit diseaseInformationReady((Disease*)hpo);
    }
}


void Regovar::getVariantInfo(int refId, QString variantId, int analysisId)
{
    openNewWindow(QUrl("qrc:/qml/Windows/VariantInfoWindow.qml"), nullptr, QString("variant_%1").arg(variantId));
    QString sRefId = QString::number(refId);
    QString sAnalysisId = QString::number(analysisId);

    QString url;
    if (analysisId == -1)
        url = QString("/search/variant/%1/%2").arg(sRefId, variantId);
    else
        url = QString("/search/variant/%1/%2/%3").arg(sRefId, variantId, sAnalysisId);

    Request* req = Request::get(url);
    connect(req, &Request::responseReceived, [this, req, analysisId](bool success, const QJsonObject& json)
    {
        if (success)
        {
            emit variantInformationReady(json["data"].toObject());
        }
        else
        {
            emit variantInformationReady(QJsonValue::Null);
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
}










void Regovar::close()
{
    settings()->save();
    QApplication::quit();
}


void Regovar::manageServerError(QJsonObject json, QString method)
{
    QString httpCode = json.contains("httpCode") ? json["httpCode"].toString() : "";

    if (httpCode == "403")
    {
        mUsersManager->switchLoginScreen(true);
    }
    else
    {
        QString code = json.contains("httpCode") ? json["code"].toString() : "";
        QString msg  = json.contains("httpCode") ? json["msg"].toString() : "";
        QString cpuiBuild = QSysInfo::buildCpuArchitecture();

        if (msg.isEmpty())
        {
            msg  = "Unmanaged error :s";
        }
        qDebug() << "ERROR Server side [" << code << "]" << msg;

        QString msgTech = "Method:       " + method + "\n";
        msgTech += "Query:        " + json["query"].toString() + "\n";
        msgTech += "Net reply:    " + json["reqError"].toString() +  "\n";
        msgTech += "Qt version:   " + QString(QT_VERSION_STR) + "\n";
        msgTech += "Build CPU:    " + QSysInfo::buildCpuArchitecture() + "\n";
        msgTech += "Current CPU:  " + QSysInfo::currentCpuArchitecture() + "\n";
        msgTech += "Kernel:       " + QSysInfo::kernelType() + " " + QSysInfo::kernelVersion() +"\n";
        msgTech += "OS:           " + QSysInfo::prettyProductName() + "\n";
        emit errorOccured(code, msg, msgTech);
    }
}
void Regovar::manageClientError(QString msg, QString code, QString method)
{
    QString msgTech = "Method:       " + method + "\n";
    msgTech += "Qt version:   " + QString(QT_VERSION_STR) + "\n";
    msgTech += "Build CPU:    " + QSysInfo::buildCpuArchitecture() + "\n";
    msgTech += "Current CPU:  " + QSysInfo::currentCpuArchitecture() + "\n";
    msgTech += "Kernel:       " + QSysInfo::kernelType() + " " + QSysInfo::kernelVersion() +"\n";
    msgTech += "OS:           " + QSysInfo::prettyProductName() + "\n";
    emit errorOccured(code, msg, msgTech);
}


QDateTime Regovar::dateFromString(QString date)
{
    date = date.trimmed();
    if (!date.isEmpty())
    {
        QStringList dateBlocks = date.split(" ");
        QString dateElmt = dateBlocks[0].trimmed();
        QString timeElmt = dateBlocks.count() > 1 ? dateBlocks[1].trimmed() : "";

        if (!dateElmt.isEmpty())
        {

            QStringList dateElmts = dateElmt.split("-");
            QDateTime result = QDateTime(QDate(dateElmts[0].toInt(), dateElmts[1].toInt(),  dateElmts[2].toInt()), QTime(12,0,0));
            if (!timeElmt.isEmpty())
            {
                QStringList timeElmts = timeElmt.split(":");
                result.setTime(QTime(timeElmts[0].toInt(), timeElmts[1].toInt()));
            }

            return result;
        }
        qDebug() << "WARNING: unable to convert \"" << date << "\" to date. Return current QDateTime";
    }
    return QDateTime::currentDateTime();
}

QString Regovar::formatNumber(int value)
{
    QLocale cLocale = QLocale::c();
    cLocale.setNumberOptions(QLocale::DefaultNumberOptions);
    QString ss = cLocale.toString(value);
    ss.replace(cLocale.groupSeparator(), ' ');
    return ss;
}
QString Regovar::formatNumber(double value)
{
    QLocale cLocale = QLocale::c();
    cLocale.setNumberOptions(QLocale::DefaultNumberOptions);
    QString ss = cLocale.toString(value);
    ss.replace(cLocale.groupSeparator(), ' ');
    return ss;
}
QString Regovar::formatDate(QDateTime date, bool withTime)
{
    if (date.isNull() || !date.isValid()) return "";

    if (withTime)
    {
        return date.toString("yyyy-MM-dd HH:mm");
    }
    return date.toString("yyyy-MM-dd");
}
QString Regovar::formatDate(QString isodate, bool withTime)
{
    return formatDate(QDateTime::fromString(isodate, Qt::ISODate), withTime);
}



void Regovar::search(QString query)
{
    setSearchInProgress(true);

    setSearchRequest(query);
    Request* req = Request::get(QString("/search/%1").arg(query));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            setSearchResult(json["data"].toObject());
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
        setSearchInProgress(false);
    });
}



void Regovar::restart()
{
    // restart:
    qApp->quit();
    QProcess::startDetached(qApp->arguments()[0], qApp->arguments());
}






QString Regovar::formatDuration(int duration)
{
    // TODO:
    return QString::number( duration / 1000);
}


QString Regovar::formatFileSize(qint64 size, qint64 uploadOffset)
{
    QStringList suffixes = {" o", "Ko", "Mo", "Go", "To", "Po"};
    QString uploadString = "";

    if (size <= 0) return "0  o";
    if (uploadOffset >=0)
    {
        if (uploadOffset < size)
        {
            float i = 0;
            double s = uploadOffset;
            while (s >= 1024 && i < suffixes.count()-1)
            {
                s /= 1024.;
                i += 1;
            }
            uploadString = QString::number( s, 'f', 2 ) + " / ";
        }
    }


    float i = 0;
    double s = size;
    while (s >= 1024 && i < suffixes.count()-1)
    {
        s /= 1024.;
        i += 1;
    }
    QString sizeString = QString::number( s, 'f', 2 );



    return QString("%1%2 %3").arg(uploadString, sizeString, suffixes[i]);
}
















// ===============================================================================
// ===============================================================================
// ===============================================================================




RegovarInfo::RegovarInfo(QObject* parent) : QObject(parent)
{

}


bool RegovarInfo::loadJson(QJsonObject json)
{
    mServerVersion = json["version"].toString();
    mWebsite = json["website"].toString();
    QJsonObject msg = json["message"].toObject();
    mWelcomMessage = msg["message"].toString();
    mWelcomMessageType = msg["type"].toString();

    if (VERSION_BUILD == 0)
    {
        mClientVersion= QString("%1.%2.dev").arg(VERSION_MAJOR).arg(VERSION_MINOR);
    }
    else
    {
        mClientVersion= QString("%1.%2.%3").arg(VERSION_MAJOR).arg(VERSION_MINOR).arg(VERSION_BUILD);
    }

    // get license text
    QFile mFile(":/license.html");
    if(mFile.open(QFile::ReadOnly | QFile::Text))
    {
        QTextStream in(&mFile);
        mLicense = in.readAll();
        mFile.close();
    }
    else
    {
        mLicense = tr("Unable to open license file");
    }



    emit configChanged();
    return true;
}
