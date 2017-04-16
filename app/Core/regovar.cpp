#include "regovar.h"
#include "tools/request.h"



Regovar* Regovar::mInstance = Q_NULLPTR;
Regovar* Regovar::i()
{
    if (mInstance == Q_NULLPTR)
    {
        mInstance = new Regovar();
    }
    return mInstance;
}

Regovar::Regovar()
{
    // Get managers.




}

Regovar::~Regovar()
{
   delete mApiManager;
}


void Regovar::init()
{
    readSettings();

    // Init managers


    // Init model
    mUser = new UserModel();
}



void Regovar::readSettings()
{
    // TODO : No hardcoded value => Load default from local config file ?
    QSettings settings;
    settings.beginGroup("RemoteServer");
    mApiRootUrl.setScheme(settings.value("scheme", "http").toString());
    mApiRootUrl.setHost(settings.value("host", "dev.regovar.org").toString());
    mApiRootUrl.setPort(settings.value("port", 80).toInt());
    settings.endGroup();
}





void Regovar::login(QString& login, QString& password)
{
    // Do nothing if user already connected
    if (mUser->isValid())
    {
        qDebug() << tr("User %1 %2 already loged in. Thanks to logout first.").arg(mUser->firstname(), mUser->lastname());
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

        Request* req = Request::post("/users/login", multiPart);
        connect(req, &Request::jsonReceived, [this, multiPart, req](const QJsonDocument& json)
        {
            if (mUser->fromJson(json))
            {
                emit loginSuccess();
            }
            else
            {
                emit loginFailed();
            }
            delete multiPart;
            delete req;
        });
    }
}

void Regovar::logout()
{
    // Do nothing if user already disconnected
    if (!mUser->isValid())
    {
        qDebug() << tr("you are already not authenticated...");
    }
    else
    {
        Request* test = Request::get("/users/logout");
        connect(test, &Request::jsonReceived, [this](const QJsonDocument& json)
        {
            mUser->clear();
            qDebug() << "You are disconnected !";
            emit logoutSuccess();
        });
    }
}

void Regovar::authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator)
{
    // Basic authentication requested by the server.
    // Try authentication using current user credentials
    qDebug() << Q_FUNC_INFO;
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


