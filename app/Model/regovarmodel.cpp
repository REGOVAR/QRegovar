#include "regovarmodel.h"
#include "request.h"



RegovarModel* RegovarModel::mInstance = Q_NULLPTR;
RegovarModel* RegovarModel::i()
{
    if (mInstance == Q_NULLPTR)
    {
        mInstance = new RegovarModel();
    }
    return mInstance;
}

RegovarModel::RegovarModel() {}
RegovarModel::~RegovarModel() {}



void RegovarModel::init()
{

    // Init managers
    readSettings();


    // Init models
    // mUser = new UserModel(); //1, "Olivier", "Gueudelot");
    mProjectsTreeView = new ProjectsTreeViewModel();
    mRemoteFilesTreeView = new FilesTreeViewModel();
    mCurrentProject = new ProjectModel();
    mUploader = new TusUploader();
    mUploader->setUploadUrl(mApiRootUrl.toString() + "/file/upload");
    mUploader->setRootUrl(mApiRootUrl.toString());
    mUploader->setChunkSize(50 * 1024);
    mUploader->setBandWidthLimit(0);


    emit currentProjectUpdated();
}



void RegovarModel::readSettings()
{
    // TODO : No hardcoded value => Load default from local config file ?
    QSettings settings;
    settings.beginGroup("RemoteServer");
    mApiRootUrl.setScheme(settings.value("scheme", "http").toString());
    mApiRootUrl.setHost(settings.value("host", "dev.regovar.org").toString());
    mApiRootUrl.setPort(settings.value("port", 80).toInt());
    settings.endGroup();
}





void RegovarModel::refreshProjectsTreeView()
{

}

void RegovarModel::loadProject(int id)
{
    Request* req = Request::get(QString("/project/%1").arg(id));
    connect(req, &Request::responseReceived, [this, req, id](bool success, const QJsonObject& json)
    {
        if (success)
        {
            if (mCurrentProject->fromJson(json["data"].toObject()))
            {
                qDebug() << Q_FUNC_INFO << "CurrentProject loaded";
                emit currentProjectUpdated();
            }
            else
            {
                qDebug() << Q_FUNC_INFO << "Failed to load project from id " << id << ". Wrong json data";
            }
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "Request error ! " << json["msg"].toString();
        }
        req->deleteLater();
    });
}

void RegovarModel::loadFilesBrowser()
{
    Request* req = Request::get(QString("/file"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            if (mRemoteFilesTreeView->fromJson(json["data"].toArray()))
            {
                qDebug() << Q_FUNC_INFO << "File browser ready";
                emit remoteFilesTreeViewUpdated();
            }
            else
            {
                qDebug() << Q_FUNC_INFO << "Failed to load remote file browser. Wrong json data";
            }
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "Request error ! " << json["msg"].toString();
        }
        req->deleteLater();
    });
}


void RegovarModel::enqueueUploadFile(QList<QString> filesPaths)
{
    // First we have to
    foreach (QString filepath, filesPaths)
    {
        mUploader->prepare(filepath);
    }
}


/*
void RegovarModel::login(QString& login, QString& password)
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

void Regovar::authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator)
{
    // Basic authentication requested by the server.
    // Try authentication using current user credentials
    if (authenticator->password() != currentUser()->password() || authenticator->user() != currentUser()->login())
    {
        authenticator->setUser(currentUser()->login());
        authenticator->setPassword(currentUser()->password());
    }
    else
    {
        request->error();
    }
}
*/
