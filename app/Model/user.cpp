#include "user.h"
#include "framework/request.h"

User::User(QObject* parent) : QObject(parent)
{
}

User::User(quint32 id, const QString& firstname, const QString& lastname, QObject* parent)
    : QObject(parent), mId(id), mFirstname(firstname), mLastname(lastname)
{
}



// Tools ========================================


bool User::fromJson(QJsonDocument json)
{
    QJsonObject data = json.object();
    return User::fromJson(data);
}

bool User::fromJson(QJsonObject json)
{
    // TODO set current user with json data
    // QString st(json.toJson(QJsonDocument::Compact));
    mId = json["id"].toInt();
    mLogin = json["login"].toString();
    mFirstname = json["firstname"].toString();
    mLastname = json["lastname"].toString();
    mEmail = json["email"].toString();
    mFunction = json["function"].toString();
    mLocation = json["location"].toString();
    mLastActivity = QDate::fromString(json["last_activity"].toString());
    qDebug() << Q_FUNC_INFO << "New User" << mId << mFirstname << mLastname;

    mRoles.clear();
    mRoles[Administration] = Write;
    mRoles[Project] = Write;
    mRoles[Pipeline] = Write;

    emit userChanged();
    return true;
}

void User::clear()
{
    mId = 0;
    mFirstname = tr("Anonymous");
    mLastname = tr("Anonymous");
    mEmail = "";
    mLogin = "";
    mPassword = "";
    mFunction = "";
    mLocation = "";
    mRoles.clear();

    emit userChanged();
}

bool User::isValid()
{
    return mId > 0;
}

bool User::isAdmin()
{
    return mRoles.contains(Administration) && mRoles[Administration] == Write;
}


User::UserRight User::role(const UserRole& role)
{
    return mRoles.contains(role) ? mRoles[role] : None;
}
void User::setRole(const UserRole& role, const UserRight& right)
{
    mRoles[role] = right;
    emit userChanged();
}
void User::setRole(const QString& role, const QString& right)
{
    // TODO
}

void User::save()
{
    if (mLogin.isEmpty())
    {
        qWarning() <<  Q_FUNC_INFO << "User's login is empty, not able to save it.";
    }

    QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    QHttpPart p1;
    p1.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"firstname\""));
    p1.setBody(mFirstname.toUtf8());
    multiPart->append(p1);
    QHttpPart p2;
    p2.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"lastname\""));
    p2.setBody(mLastname.toUtf8());
    multiPart->append(p2);
    QHttpPart p3;
    p3.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"email\""));
    p3.setBody(mEmail.toUtf8());
    multiPart->append(p3);
    QHttpPart p4;
    p4.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"function\""));
    p4.setBody(mFunction.toUtf8());
    multiPart->append(p4);
    QHttpPart p5;
    p5.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"location\""));
    p5.setBody(mLocation.toUtf8());
    multiPart->append(p5);

    if (!mPassword.isEmpty())
    {
        QHttpPart p6;
        p6.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"password\""));
        p6.setBody(mPassword.toUtf8());
        multiPart->append(p6);
    }
    QHttpPart p7;
    p7.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"login\""));
    p7.setBody(mLogin.toUtf8());
    multiPart->append(p7);

    Request* request;
    if (mId == 0)
    {
        request = Request::post("/user", multiPart);
    }
    else
    {
        request = Request::put(QString("/user/%1").arg(mId), multiPart);
    }

    connect(request, &Request::responseReceived, [this, multiPart, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            mId = data["id"].toInt();
            qDebug() << Q_FUNC_INFO << "User saved";
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Request error occured";
        }
        multiPart->deleteLater();
        request->deleteLater();
    });
}









