#include <QQmlContext>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQmlComponent>

#include "regovar.h"
#include "request.h"

#include "Model/file/file.h"
#include "Model/analysis/filtering/reference.h"


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
    mProjectsTreeView = new ProjectsTreeModel();
    mCurrentProject = new Project();
    mUploader = new TusUploader();
    resetNewAnalysisWizardModels();
    mUploader->setUploadUrl(mApiRootUrl.toString() + "/file/upload");
    mUploader->setRootUrl(mApiRootUrl.toString());
    mUploader->setChunkSize(50 * 1024);
    mUploader->setBandWidthLimit(0);


    // Connections
    connect(mUploader,  SIGNAL(filesEnqueued(QHash<QString,QString>)), this, SLOT(filesEnqueued(QHash<QString,QString>)));
    connect(&mWebSocket, &QWebSocket::connected, this, &Regovar::onWebsocketConnected);
    connect(&mWebSocket, &QWebSocket::disconnected, this, &Regovar::onWebsocketClosed);


    emit currentProjectChanged();

    // DEBUG
    // loadAnalysis(4);
    mWebSocket.open(QUrl(mWebsocketUrl));
    getWelcomLastData();
}


void Regovar::onWebsocketConnected()
{
    connect(&mWebSocket, &QWebSocket::textMessageReceived, this, &Regovar::onWebsocketReceived);
    mWebSocket.sendTextMessage(QStringLiteral("{ \"action\" : \"hello\"}"));
}

void Regovar::onWebsocketReceived(QString message)
{
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
    QJsonObject obj = doc.object();
    if (obj["action"].toString() != "hello") qDebug() << "Websocket" << message;
    emit websocketMessageReceived(obj["action"].toString(), obj["data"].toObject());
}

void Regovar::onWebsocketClosed()
{
    disconnect(&mWebSocket, &QWebSocket::textMessageReceived, 0, 0);
    mWebSocket.open(QUrl(mWebsocketUrl));
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

void Regovar::loadProject(int id)
{
    Request* req = Request::get(QString("/project/%1").arg(id));
    connect(req, &Request::responseReceived, [this, req, id](bool success, const QJsonObject& json)
    {
        if (success)
        {
            if (mCurrentProject->fromJson(json["data"].toObject()))
            {
                qDebug() << Q_FUNC_INFO << "CurrentProject loaded";
                emit currentProjectChanged();
            }
            else
            {
                qDebug() << Q_FUNC_INFO << "Failed to load project from id " << id << ". Wrong json data";
            }
        }
        else
        {
            regovar->raiseError(json);
        }
        req->deleteLater();
    });
}



void Regovar::getWelcomLastData()
{
    Request* req = Request::get(QString("/"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            mLastAnalyses = data["last_analyses"].toArray();
            emit lastAnalysesChanged();
            mLastEvents = data["last_events"].toArray();
            emit lastEventChanged();
            mLastSubjects = data["last_subjects"].toArray();
            emit lastSubjectsChanged();

            // Get referencial available
            mReferenceDefault = data["default_reference_id"].toInt();
            foreach (QJsonValue jsonVal, data["references"].toArray())
            {
                Reference* ref = new Reference();
                ref->fromJson(jsonVal.toObject());
                mReferences.append(ref);
            }
        }
        else
        {
            regovar->raiseError(json);
        }
        req->deleteLater();
    });
}


void Regovar::resetNewAnalysisWizardModels()
{
    mNewPipelineAnalysis = new PipelineAnalysis();
    mNewFilteringAnalysis = new FilteringAnalysis();
    emit newPipelineAnalysisChanged();
    emit newFilteringAnalysisChanged();
}

void Regovar::openAnalysis(int analysisId)
{
    loadAnalysis(analysisId);
}

void Regovar::loadAnalysis(int id)
{
    Request* req = Request::get(QString("/analysis/%1").arg(id));
    connect(req, &Request::responseReceived, [this, req, id](bool success, const QJsonObject& json)
    {
        if (success)
        {
            int lastId = mOpenAnalyses.count();
            mOpenAnalyses.append(new FilteringAnalysis(this));
            FilteringAnalysis* analysis = mOpenAnalyses[lastId];

            if (analysis->fromJson(json["data"].toObject()))
            {
                // Create new QML window
                QDir dir = QDir::currentPath();
                QString file = dir.filePath("UI/AnalysisWindow.qml");
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
                }
                i->setParent(0);

                qDebug() << Q_FUNC_INFO << "Filtering Analysis (id=" << id << ") Loaded. Window id=" << lastId;

            }
            else
            {
                qDebug() << Q_FUNC_INFO << "Failed to load analysis from id " << id << ". Wrong json data";
            }
        }
        else
        {
            regovar->raiseError(json);
        }
        req->deleteLater();
    });
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
            regovar->raiseError(json);
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
    Request* req = Request::get(QString("/sample/browserTree/%1").arg(2)); // refId));
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
            regovar->raiseError(json);
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
                else
                {
                    regovar->raiseError(json);
                }
                req2->deleteLater();
            });
        }
        else
        {
            regovar->raiseError(json);
        }
        req->deleteLater();
    });

}
void Regovar::newAnalysis(QJsonObject data)
{
    // TODO
    emit analysisCreationDone(true, 6);
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
    if (code.isEmpty() && msg.isEmpty())
    {
        code = "00000";
        msg  = "Unable to connect to the server.";
    }
    qDebug() << "ERROR Server side [" << code << "]" << msg;
    emit onError(code, msg);
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
            regovar->raiseError(json);
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

