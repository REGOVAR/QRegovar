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
    mUser = new User(-1, "Anonymous", "");
}



void Regovar::readSettings()
{
    // TODO : No hardcoded value => Load default from local config file ?
    QSettings settings;
    settings.beginGroup("RemoteServer");
    mApiRootUrl.setScheme(settings.value("scheme", "https").toString());
    mApiRootUrl.setHost("pirus.absolumentg.fr"); //settings.value("host", "annso.absolumentg.fr").toString());
    mApiRootUrl.setPort(settings.value("port", 443).toInt());
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
        // store login and password as it may be ask later if network authentication problem
        mUser->setLogin(login);
        mUser->setPassword(password);
        // TODO use Regovar api /user/login
        Request* test = Request::get("/ref");
        connect(test, &Request::jsonReceived, [this](const QJsonDocument& json)
        {
            if (mUser->loginUser(json))
            {
                emit loginSuccess();
            }
            else
            {
                emit loginFailed();
            }
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
        Request* test = Request::get("/user/logout");
        connect(test, &Request::jsonReceived, [this](const QJsonDocument& json)
        {
            // Create a new user ?? no!!! => mUser = new User(-1, "Anonymous", "");
            mUser->logoutUser();
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


