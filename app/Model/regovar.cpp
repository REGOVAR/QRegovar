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




RegovarInfo::RegovarInfo(QObject* parent) : QObject(parent)
{

}


void RegovarInfo::fromJson(QJsonObject json)
{
    mServerVersion = json["version"].toString();
    mWebsite = json["website"].toString();

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
}

















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
    mUser = new User(1, "MyFirstname", "MyLastname");
    mConfig = new RegovarInfo();
    mAdmin = new Admin();
    mMainMenu = new RootMenu(this);
    mMainMenu->initMain();

    // Init network manager
    mNetworkManager = new NetworkManager();
    mNetworkManager->setServerUrl(mSettings->serverUrl());
    mNetworkManager->setSharedUrl(mSettings->sharedUrl());

    // Init file manager
    mFilesManager = new FilesManager();
    mFilesManager->setCacheDir(mSettings->localCacheDir());
    mFilesManager->setCacheMaxSize(mSettings->localCacheMaxSize());

    // Init others managers
    mProjectsManager = new ProjectsManager(this);
    mSubjectsManager = new SubjectsManager(this);
    mSamplesManager = new SamplesManager(mSettings->defaultReference());
    mAnalysesManager = new AnalysesManager(this);
    mPanelsManager = new PanelsManager(this);
    mToolsManager = new ToolsManager(this);

    // Init sub models
    mProjectsManager->refresh();
    mSubjectsManager->refresh();
    mPanelsManager->refresh();

    // Load misc data
    loadWelcomData();
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
            mConfig->fromJson(data);

            // Last analyses
            while(!mLastAnalyses.empty()) mLastAnalyses.pop_back();
            for (const QJsonValue& val: data["last_analyses"].toArray())
            {
                QJsonObject item = val.toObject();
                QDateTime date = QDateTime::fromString(item["update_date"].toString(), Qt::ISODate);
                item["update_date"] = date.toString("yyyy-MM-dd hh:mm");
                mLastAnalyses.append(item);
            }
            // Last subjects
            mLastSubjects.clear();
            for (const QJsonValue& val: data["last_subjects"].toArray())
            {
                QJsonObject item = val.toObject();
                Subject* sbj = subjectsManager()->getOrCreateSubject(item["id"].toInt());
                sbj->fromJson(item);
                mLastSubjects.append(sbj);
            }
            // Last events
//            while(!mLastSubjects.empty()) mLastSubjects.pop_back();
//            for (const QJsonValue& val: data["last_events"].toArray())
//            {
//                QJsonObject item = val.toObject();
//                QDateTime date = QDateTime::fromString(item["update_date"].toString(), Qt::ISODate);
//                item["update_date"] = date.toString("yyyy-MM-dd hh:mm");
//                //mLastSubjects.append(item);
//            }
            emit lastDataChanged();

            // Get referencial available
            for (const QJsonValue& jsonVal: data["references"].toArray())
            {
                QJsonObject refD = jsonVal.toObject();
                int id = refD["id"].toInt();
                Reference* ref = referenceFromId(id);
                if (ref == nullptr)
                {
                    ref = new Reference(this);
                    ref->fromJson(jsonVal.toObject());
                    if (ref->id() > 0) mReferences.append(ref);
                }
            }
            emit referencesChanged();


            // Get milestones data
            QJsonObject milestones;
            for (const QJsonValue& val: data["milestones"].toArray())
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
            emit configChanged();

            // Timer to update "welcom data" in 30s
            QTimer::singleShot(30000, regovar, SLOT(loadWelcomData()));

        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
        setWelcomIsLoading(true);
    });
}







bool Regovar::openNewWindow(QUrl qmlUrl, QObject* model)
{
    // Store model of the new windows in a collection readable from qml
    int lastId = mOpenWindowModels.count();
    mOpenWindowModels.append(model);

    // Create new QML window
    QQmlComponent *c = new QQmlComponent(mQmlEngine, qmlUrl, QQmlComponent::PreferSynchronous);
    QObject* o = c->create();
    QQuickWindow *i = qobject_cast<QQuickWindow*>(o);
    QQmlEngine::setObjectOwnership(i, QQmlEngine::CppOwnership);

    // Call init qml method to retrieve its model
    QMetaObject::invokeMethod(i, "initFromCpp", Q_ARG(QVariant, lastId));

    // Setup qml window's parent
    i->setVisible(true);
    QObject* root = mQmlEngine->rootObjects()[0];
    QQuickWindow* rootWin = qobject_cast<QQuickWindow*>(root);
    if (!rootWin)
    {
        qFatal("Error: Your root item has to be a window.");
        return false;
    }
    i->setParent(0);
    return true;
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
    emit fileInformationSearching();
    File* file = mFilesManager->getOrCreateFile(fileId);
    file->load(false);
    emit fileInformationReady(file);
}


void Regovar::getPanelInfo(QString panelId)
{
    emit panelInformationSearching();
    Panel* panel = mPanelsManager->getOrCreatePanel(panelId);
    panel->load(false);
    emit panelInformationReady(panel);
}


void Regovar::getSampleInfo(int sampleId)
{
    emit sampleInformationSearching();
    Sample* sample= mSamplesManager->getOrCreate(sampleId);
    sample->load(false);
    emit sampleInformationReady(sample);
}


void Regovar::getUserInfo(int)
{
    emit userInformationSearching();
    //User* sample= mUserManager->getOrCreate(userId);
    //sample->load(false);
    emit userInformationReady(mUser);
}


void Regovar::getPipelineInfo(int pipelineId)
{
    emit pipelineInformationSearching();
    QString sPipelineId = QString::number(pipelineId);
    QString url = QString("/pipeline/%1").arg(sPipelineId);

    Request* req = Request::get(url);
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            emit pipelineInformationReady(json["data"].toObject());
        }
        else
        {
            emit pipelineInformationReady(QJsonValue::Null);
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}


void Regovar::getGeneInfo(QString geneName, int analysisId)
{
    emit geneInformationSearching();
    QString sAnalysisId = QString::number(analysisId);
    QString url;
    if (analysisId == -1)
        url = QString("/search/gene/%1").arg(geneName);
    else
        url = QString("/search/gene/%1/%2").arg(geneName, sAnalysisId);

    Request* req = Request::get(url);
    connect(req, &Request::responseReceived, [this, req, analysisId](bool success, const QJsonObject& json)
    {
        if (success)
        {
            emit geneInformationReady(json["data"].toObject());
        }
        else
        {
            emit geneInformationReady(QJsonValue::Null);
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}


void Regovar::getPhenotypeInfo(QString phenotypeId)
{
    emit phenotypeInformationSearching();
    QString url = QString("/search/phenotype/%1").arg(phenotypeId);

    Request* req = Request::get(url);
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            emit phenotypeInformationReady(json["data"].toObject());
        }
        else
        {
            emit phenotypeInformationReady(QJsonValue::Null);
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}


void Regovar::getVariantInfo(int refId, QString variantId, int analysisId)
{
    emit variantInformationSearching();
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
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}










void Regovar::close()
{
    settings()->save();
    QApplication::quit();
}


void Regovar::disconnectUser()
{
    qDebug() << "disconnect user !";
}

void Regovar::quit()
{
    qDebug() << "quit regovar app !";
}

void Regovar::raiseError(QJsonObject json)
{
    QString code = json["code"].toString();
    QString msg  = json["msg"].toString();
    QString cpuiBuild = QSysInfo::buildCpuArchitecture();

    if (msg.isEmpty())
    {
        msg  = "Unmanaged error :s";
    }
    qDebug() << "ERROR Server side [" << code << "]" << msg;

    QString msgTech = "Method:       " + json["method"].toString() + "\n";
    msgTech += "Query:        " + json["query"].toString() + "\n";
    msgTech += "Net reply:    " + json["reqError"].toString() +  "\n";
    msgTech += "Qt version:   " + QString(QT_VERSION_STR) + "\n";
    msgTech += "Build CPU:    " + QSysInfo::buildCpuArchitecture() + "\n";
    msgTech += "Current CPU:  " + QSysInfo::currentCpuArchitecture() + "\n";
    msgTech += "Kernel:       " + QSysInfo::kernelType() + " " + QSysInfo::kernelVersion() +"\n";
    msgTech += "OS:           " + QSysInfo::prettyProductName() + "\n";



    emit errorOccured(code, msg, msgTech);
}


QDateTime Regovar::dateFromShortString(QString date)
{
    QStringList dateElmt = date.split("-");
    return QDateTime(QDate(dateElmt[0].toInt(), dateElmt[1].toInt(),  dateElmt[2].toInt()), QTime(12,0,0));
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
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
        setSearchInProgress(false);
    });
}









void Regovar::login(QString& login, QString& password)
{
    // Do nothing if user already connected
    if (mUser->isValid())
    {
        qDebug() << Q_FUNC_INFO << QString("User %1 %2 already loged in. Thanks to logout first.").arg(mUser->firstname(), mUser->lastname());
    }
    else
    {
        // Store login and password as it may be ask later if network authentication problem
        mUser->setLogin(login);
        mUser->setPassword(password);
        // TODO use Regovar api /user/login
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
        QHttpPart p1;
        p1.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"login\""));
        p1.setBody(login.toUtf8());
        QHttpPart p2;
        p2.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"password\""));
        p2.setBody(password.toUtf8());

        multiPart->append(p1);
        multiPart->append(p2);

        Request* req = Request::post("/user/login", multiPart);
        connect(req, &Request::responseReceived, [this, multiPart, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                if (mUser->fromJson(json["data"].toObject()))
                {
                    emit loginSuccess();
                }
            }
            emit loginFailed();
            multiPart->deleteLater();
            req->deleteLater();
        });
    }
}

void Regovar::logout()
{
    // Do nothing if user already disconnected
    if (!mUser->isValid())
    {
        qDebug() << Q_FUNC_INFO << "You are already not authenticated...";
    }
    else
    {
        Request* test = Request::get("/user/logout");
        connect(test, &Request::responseReceived, [this](bool, const QJsonObject&)
        {
            mUser->clear();
            qDebug() << Q_FUNC_INFO << "You are disconnected !";
            emit logoutSuccess();
        });
    }
}





QString Regovar::sizeToHumanReadable(qint64 size, qint64 uploadOffset)
{
    QStringList suffixes = {"o", "Ko", "Mo", "Go", "To", "Po"};
    QString uploadString = "";

    if (size == 0) return "0 o";
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
