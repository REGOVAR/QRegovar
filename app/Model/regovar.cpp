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
    // Init managers
    readSettings();


    // Create models
    mUser = new User(1, "Olivier", "Gueudelot");
    mConfig = new RegovarInfo();
    mAdmin = new Admin();
    mProjectsManager = new ProjectsManager();
    mSubjectsManager = new SubjectsManager();
    mSamplesManager = new SamplesManager(mReferenceDefault);
    mFilesManager = new FilesManager();
    mAnalysesManager = new AnalysesManager();
    mToolsManager = new ToolsManager();

    // Connections
    connect(&mWebSocket, &QWebSocket::connected, this, &Regovar::onWebsocketConnected);
    connect(&mWebSocket, &QWebSocket::disconnected, this, &Regovar::onWebsocketClosed);
    connect(&mWebSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(onWebsocketError(QAbstractSocket::SocketError)));
    // connect(&mWebSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)), this, SLOT(onWebsocketStateChanged(QAbstractSocket::SocketState)));
    mWebSocket.open(QUrl(mWebsocketUrl));

    // Init sub models
    mProjectsManager->refreshProjectsList();
    mSubjectsManager->refreshSubjectsList();

    // Load misc data
    loadWelcomData();
}


void Regovar::onWebsocketConnected()
{
    setConnectionStatus(ready);
    connect(&mWebSocket, &QWebSocket::textMessageReceived, this, &Regovar::onWebsocketReceived);
    mWebSocket.sendTextMessage(QStringLiteral("{ \"action\" : \"hello\"}"));
}

void Regovar::onWebsocketReceived(QString message)
{
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
    QJsonObject obj = doc.object();
    QString action = obj["action"].toString();
    QJsonObject data = obj["data"].toObject();

    // TODO: rework process WS for Sample
    if (action == "import_vcf_processing")
    {
        double progressValue = data["progress"].toDouble();
        QString status = data["status"].toString();

        for (const QJsonValue& json: data["samples"].toArray())
        {
            QJsonObject obj = json.toObject();
            int sid = obj["id"].toInt();
            for (QObject* o: mSamplesManager->samplesList())
            {
                Sample* sample = qobject_cast<Sample*>(o);
                if (sample->id() == sid)
                {
                    sample->setStatus(status);
                    QJsonObject statusInfo;
                    statusInfo.insert("status", status);
                    statusInfo.insert("label", sample->statusToLabel(sample->status(), progressValue));
                    sample->setStatusUI(QVariant::fromValue(statusInfo));
                    break;
                }
            }
        }
    }
    else if (mWsFilesActionsList.indexOf(action) != -1)
    {
        mFilesManager->processPushNotification(action, data);
    }
    else if (obj["action"].toString() != "hello")
    {
        qDebug() << "WS WARNING: Websocket Unknow message" << message;
    }
    emit websocketMessageReceived(action, data);
}

void Regovar::onWebsocketClosed()
{
    disconnect(&mWebSocket, &QWebSocket::textMessageReceived, 0, 0);
    mWebSocket.open(QUrl(mWebsocketUrl));
}

void Regovar::onWebsocketError(QAbstractSocket::SocketError err)
{
    if (err != QAbstractSocket::RemoteHostClosedError)
    {
        qDebug() << "WS ERROR : " << err;
        setConnectionStatus(err == QAbstractSocket::ConnectionRefusedError ? unreachable : error);
    }
}

void Regovar::onWebsocketStateChanged(QAbstractSocket::SocketState)
{
    // qDebug() << "WS state" << state;
}


void Regovar::readSettings()
{
    // TODO: Load default from settings
    mReferenceDefault = 3;

    // TODO : No hardcoded value => Load default from local config file ?
    QSettings settings;
    QString schm = settings.value("scheme", "http").toString();
    QString host = settings.value("host", "dev.regovar.org").toString();
    int port = settings.value("port", 80).toInt();

    // Localsite server
    settings.beginGroup("LocalServer");
    mApiRootUrl.setScheme(schm);
    mApiRootUrl.setHost(host);
    mApiRootUrl.setPort(port);
    // Sharing server
//    settings.beginGroup("SharingServer");
//    mApiRootUrl.setScheme(settings.value("scheme", "http").toString());
//    mApiRootUrl.setHost(settings.value("host", "dev.regovar.org").toString());
//    mApiRootUrl.setPort(settings.value("port", 80).toInt());

    // Websocket
    mWebsocketUrl.setScheme(schm == "https" ? "wss" : "ws");
    mWebsocketUrl.setHost(host);
    mWebsocketUrl.setPath("/ws");
    mWebsocketUrl.setPort(port);

    settings.endGroup();
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
            for (const QJsonValue& val: data["last_analyses"].toArray())
            {
                QJsonObject item = val.toObject();
                QDateTime date = QDateTime::fromString(item["update_date"].toString(), Qt::ISODate);
                item["update_date"] = date.toString("yyyy-MM-dd hh:mm");
                mLastAnalyses.append(item);
            }
            // Last subjects
            for (const QJsonValue& val: data["last_subjects"].toArray())
            {
                QJsonObject item = val.toObject();
                QDateTime date = QDateTime::fromString(item["update_date"].toString(), Qt::ISODate);
                item["update_date"] = date.toString("yyyy-MM-dd hh:mm");
                mLastSubjects.append(item);
            }
            // Last events
            for (const QJsonValue& val: data["last_events"].toArray())
            {
                QJsonObject item = val.toObject();
                QDateTime date = QDateTime::fromString(item["update_date"].toString(), Qt::ISODate);
                item["update_date"] = date.toString("yyyy-MM-dd hh:mm");
                mLastSubjects.append(item);
            }
            emit lastDataChanged();

            // Get referencial available
            mReferenceDefault = data["default_reference_id"].toInt();
            for (const QJsonValue& jsonVal: data["references"].toArray())
            {
                Reference* ref = new Reference();
                ref->fromJson(jsonVal.toObject());
                if (ref->id() > 0) mReferences.append(ref);
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

























void Regovar::getVariantInfo(int refId, QString variantId, int analysisId)
{
    QString sRefId = QString::number(refId);
    QString sAnalysisId = QString::number(analysisId);

    QString url;
    if (analysisId == -1)
        url = QString("/search/variant/%1/%2").arg(sRefId, variantId);
    else
        url = QString("/search/variant/%1/%2/%3").arg(sRefId, variantId, sAnalysisId);

    Request* req = Request::get(url);
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            emit variantInformationReady(json["data"].toObject());
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}







void Regovar::close()
{
    emit onClose();
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



void Regovar::onAuthenticationRequired(QNetworkReply* request, QAuthenticator* authenticator)
{
    // Basic authentication requested by the server.
    // Try authentication using current user credentials
    if (authenticator->password() != user()->password() || authenticator->user() != user()->login())
    {
        authenticator->setUser(user()->login());
        authenticator->setPassword(user()->password());
    }
    else
    {
        request->error();
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
