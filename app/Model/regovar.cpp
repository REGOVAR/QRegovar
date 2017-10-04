#include <QQmlContext>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQmlComponent>
#include <QAbstractSocket>
#include <QSysInfo>
#include "regovar.h"
#include "request.h"

#include "Model/file/file.h"
#include "Model/analysis/filtering/reference.h"
#include "sample/sample.h"




RegovarConfig::RegovarConfig(QObject* parent) : QObject(parent)
{

}


void RegovarConfig::fromJson(QJsonObject json)
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


    // Init models
    // mUser = new UserModel(); //1, "Olivier", "Gueudelot");
    mConfig = new RegovarConfig();
    mProjectsTreeView = new ProjectsTreeModel();
    mUploader = new TusUploader();
    mNewPipelineAnalysis = new PipelineAnalysis();
    mNewFilteringAnalysis = new FilteringAnalysis();
    mUploader->setUploadUrl(mApiRootUrl.toString() + "/file/upload");
    mUploader->setRootUrl(mApiRootUrl.toString());
    mUploader->setChunkSize(50 * 1024);
    mUploader->setBandWidthLimit(0);


    // Connections
    connect(mUploader,  SIGNAL(filesEnqueued(QHash<QString,QString>)), this, SLOT(filesEnqueued(QHash<QString,QString>)));
    connect(&mWebSocket, &QWebSocket::connected, this, &Regovar::onWebsocketConnected);
    connect(&mWebSocket, &QWebSocket::disconnected, this, &Regovar::onWebsocketClosed);
    connect(&mWebSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(onWebsocketError(QAbstractSocket::SocketError)));
    // connect(&mWebSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)), this, SLOT(onWebsocketStateChanged(QAbstractSocket::SocketState)));
    mWebSocket.open(QUrl(mWebsocketUrl));


    // Init sub models
    initFlatProjectList();
    mProjectsTreeView->refresh();

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
    if (obj["action"].toString() != "hello") qDebug() << "Websocket" << message;
    QString action = obj["action"].toString();
    QJsonObject data = obj["data"].toObject();

    if (action == "import_vcf_processing")
    {
        double progressValue = data["progress"].toDouble();
        QString status = data["status"].toString();

        foreach(QJsonValue json, data["samples"].toArray())
        {
            QJsonObject obj = json.toObject();
            int sid = obj["id"].toInt();
            foreach (QObject* o, mRemoteSamplesList)
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





void Regovar::refreshProjectsTreeView()
{
    qDebug() << Q_FUNC_INFO << "TODO";
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
            mLastAnalyses = data["last_analyses"].toArray();
            emit lastAnalysesChanged();
            mLastEvents = data["last_events"].toArray();
            emit lastEventChanged();
            mLastSubjects = data["last_subjects"].toArray();
            emit lastSubjectsChanged();

            // Get referencial available
            mReferenceDefault = data["default_reference_id"].toInt();
            mSelectedReference = 0;
            foreach (QJsonValue jsonVal, data["references"].toArray())
            {
                Reference* ref = new Reference();
                ref->fromJson(jsonVal.toObject());
                if (ref->id() > 0) mReferences.append(ref);
            }
            emit referencesChanged();
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


void Regovar::initFlatProjectListRecursive(QJsonArray data, QString prefix)
{
    foreach(const QJsonValue json, data)
    {
        QJsonObject p = json.toObject();
        QString name = p["name"].toString();


        // If folder, need to retrieve subitems recursively
        if (p["is_folder"].toBool())
        {
            initFlatProjectListRecursive(p["children"].toArray(), prefix + name + "/");
        }
        else
        {
            p.insert("fullpath", prefix + name);
            Project* proj = new Project();
            proj->fromJson(p);
            mProjectsList << proj;
        }
    }
}

void Regovar::initFlatProjectList()
{
    Request* request = Request::get("/project/browserTree");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mProjectsList.clear();
            initFlatProjectListRecursive(json["data"].toArray(), "");
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build projects tree model (due to request error)";
        }
        request->deleteLater();
    });
}



void Regovar::resetNewAnalysisWizardModels()
{
    // clear data in newAnalyses wrappers

    mNewFilteringAnalysis->removeSamples(mNewFilteringAnalysis->samples4qml());
    mNewFilteringAnalysis->samples().clear();
    mNewFilteringAnalysis->setComment("");
    mNewFilteringAnalysis->setName("");
    mNewFilteringAnalysis->setIsTrio(false);

    // reset references
    mSelectedReference = 0;
    int idx = 0;
    foreach (QObject* o, mReferences)
    {
        Reference* ref = qobject_cast<Reference*>(o);
        if (ref->id() == mReferenceDefault)
        {
            mSelectedReference = idx;
            mNewFilteringAnalysis->setReference(ref);
            break;
        }
        ++idx;
    }




    // Pipeline analysis


//    mNewPipelineAnalysis = new PipelineAnalysis();
//    mNewFilteringAnalysis = new FilteringAnalysis();
    emit newPipelineAnalysisChanged();
    emit newFilteringAnalysisChanged();
}



Reference* Regovar::referencesFromId(int id)
{
    foreach (QObject* o, mReferences)
    {
        Reference* ref = qobject_cast<Reference*>(o);
        if (ref->id()==id)
        {
            return ref;
        }
    }
    return nullptr;
}



void Regovar::openAnalysis(int id)
{
    Request* req = Request::get(QString("/analysis/%1").arg(id));
    connect(req, &Request::responseReceived, [this, req, id](bool success, const QJsonObject& json)
    {
        if (success)
        {
            if (openAnalysis(json["data"].toObject()))
            {
                qDebug() << Q_FUNC_INFO << "Filtering Analysis (id=" << id << ") Loaded.";
            }
            else
            {
                qDebug() << Q_FUNC_INFO << "Failed to load analysis from id " << id << ". Wrong json data";
            }
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
bool Regovar::openAnalysis(QJsonObject data)
{
    int lastId = mOpenAnalyses.count();
    mOpenAnalyses.append(new FilteringAnalysis(this));
    FilteringAnalysis* analysis = mOpenAnalyses[lastId];

    if (analysis->fromJson(data))
    {
        // Create new QML window
        QUrl url = QUrl("qrc:/qml/AnalysisWindow.qml");
        QQmlComponent *c = new QQmlComponent(mQmlEngine, url, QQmlComponent::PreferSynchronous);
        QObject* o = c->create();
        QQuickWindow *i = qobject_cast<QQuickWindow*>(o);
        QQmlEngine::setObjectOwnership(i, QQmlEngine::CppOwnership);

        //i->setProperty("winId", lastId);
        QMetaObject::invokeMethod(i, "initFromCpp", Q_ARG(QVariant, lastId));
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
    return false;
}



void Regovar::setSelectedReference(int idx)
{
    mSelectedReference=idx;
    Reference* ref = qobject_cast<Reference*>(mReferences[idx]);
    mNewFilteringAnalysis->setReference(ref, false);
    emit selectedReferenceChanged();
}

void Regovar::setSelectedProject(int idx)
{
    mSelectedProject=idx;
    emit selectedProjectChanged();
}




void Regovar::loadFilesBrowser()
{
    Request* req = Request::get(QString("/file"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mRemoteFilesList.clear();
            foreach( QJsonValue data, json["data"].toArray())
            {
                File* file = new File();
                file->fromJson(data.toObject());
                mRemoteFilesList.append(file);
            }
            emit remoteFilesListChanged();
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


void Regovar::filesEnqueued(QHash<QString,QString> mapping)
{
    qDebug() << "Upload mapping Done !";
    foreach (QString key, mapping.keys())
    {
        qDebug() << key << " => " << mapping[key];
    }
}






void Regovar::loadSampleBrowser(int refId)
{
    Request* req = Request::get(QString("/sample/browserTree/%1").arg(refId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mRemoteSamplesList.clear();
            foreach( QJsonValue sbjData, json["data"].toArray())
            {
                QJsonObject subject = sbjData.toObject();
                // TODO subject info
                foreach( QJsonValue splData, subject["samples"].toArray())
                {
                    Sample* sample = new Sample();
                    sample->fromJson(splData.toObject());
                    mRemoteSamplesList.append(sample);
                }
            }
            emit remoteSamplesListChanged();
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






void Regovar::newProject(QString name, QString comment)
{
    QJsonObject body;
    body.insert("name", name);
    body.insert("is_filter", false);
    body.insert("comment", comment);

    Request* req = Request::post(QString("/project"), QJsonDocument(body).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject projectData = json["data"].toObject();
            Request* req2 = Request::get(QString("/project/%1").arg(projectData["id"].toInt()));
            connect(req2, &Request::responseReceived, [this, req2](bool success, const QJsonObject& json)
            {
                if (success)
                {
                    openProject(json);
                }
                else
                {
                    QJsonObject jsonError = json;
                    jsonError.insert("method", Q_FUNC_INFO);
                    regovar->raiseError(jsonError);
                }
                req2->deleteLater();
            });
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


void Regovar::openProject(int id)
{
    Request* req = Request::get(QString("/project/%1").arg(id));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            openProject(json);
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

void Regovar::openProject(QJsonObject json)
{
    Project* project = new Project(regovar);

    if (project->fromJson(json["data"].toObject()))
    {
        // store project model
        mProjectsOpen.append(project);
        qDebug() << Q_FUNC_INFO << "Project open !";

        emit projectsTreeViewChanged();
        emit projectsOpenChanged();
        emit projectCreationDone(true, mProjectsOpen.count() - 1);
    }
    else
    {
        qDebug() << Q_FUNC_INFO << "Failed to load project data.";
    }
}

bool Regovar::newAnalysis(QString type)
{
    if (type == "filtering")
    {
        QJsonArray ids;
        foreach (Sample* s, mNewFilteringAnalysis->samples())
        {
            ids.append(QJsonValue(s->id()));
        }

        QJsonObject settings;
        QJsonArray dbs;
        settings.insert("annotations_db", dbs);
        if (mNewFilteringAnalysis->isTrio())
        {
            QJsonObject trioSettings;
            trioSettings.insert("child_id", mNewFilteringAnalysis->trioChild()->id());
            trioSettings.insert("child_index", mNewFilteringAnalysis->trioChild()->isIndex());
            trioSettings.insert("child_sex", mNewFilteringAnalysis->trioChild()->sex());
            trioSettings.insert("mother_id", mNewFilteringAnalysis->trioMother()->id());
            trioSettings.insert("mother_index", mNewFilteringAnalysis->trioMother()->isIndex());
            trioSettings.insert("father_id", mNewFilteringAnalysis->trioFather()->id());
            trioSettings.insert("father_index", mNewFilteringAnalysis->trioFather()->isIndex());
            settings.insert("trio", trioSettings);
        }
        else
        {
            settings.insert("trio", false);
        }

        QJsonObject body;
        Project* proj = qobject_cast<Project*>(mProjectsList[mSelectedProject]);
        body.insert("project_id", proj->id());
        body.insert("reference_id", mNewFilteringAnalysis->refId());
        body.insert("name", mNewFilteringAnalysis->name());
        body.insert("samples_ids", ids);
        body.insert("settings", settings);

        Request* req = Request::post(QString("/analysis"), QJsonDocument(body).toJson());
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                QJsonObject data = json["data"].toObject();
                // Open new analysis
                openAnalysis(data);
                int id = data["id"].toInt();

                // Start creation of the working table by sending the first "filtering" query
                QJsonObject body;
                body.insert("filter", data["filter"].toArray());
                body.insert("fields", data["fields"].toArray());
                Request* req2 = Request::post(QString("/analysis/%1/filtering").arg(id), QJsonDocument(body).toJson());
                req2->deleteLater();

                // notify HMI that analysis is created
                emit analysisCreationDone(true, id);
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
    else if (type == "pipeline")
    {

    }
	return true;
}
void Regovar::newSubject(QJsonObject data)
{
    // TODO
    emit subjectCreationDone(true, 1);
}


void Regovar::enqueueUploadFile(QStringList filesPaths)
{
    mUploader->enqueue(filesPaths);
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



FilteringAnalysis* Regovar::getAnalysisFromWindowId(int winId)
{
    return mOpenAnalyses[winId];
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








/*
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
        connect(test, &Request::responseReceived, [this](bool success, const QJsonObject& json)
        {
            mUser->clear();
            qDebug() << Q_FUNC_INFO << "You are disconnected !";
            emit logoutSuccess();
        });
    }
}
*/


void Regovar::onAuthenticationRequired(QNetworkReply* request, QAuthenticator* authenticator)
{
    // Basic authentication requested by the server.
    // Try authentication using current user credentials
//    if (authenticator->password() != currentUser()->password() || authenticator->user() != currentUser()->login())
//    {
//        authenticator->setUser(currentUser()->login());
//        authenticator->setPassword(currentUser()->password());
//    }
//    else
//    {
//        request->error();
//    }
}

