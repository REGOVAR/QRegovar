#include "usermodel.h"
#include "tools/request.h"

UserModel::UserModel(QObject* parent) : ResourceModel(parent)
{
}

UserModel::UserModel(quint32 id, const QString& firstname, const QString& lastname, QObject* parent)
    : ResourceModel(id, parent), mFirstname(firstname), mLastname(lastname)
{
}



// Tools ========================================


bool UserModel::fromJson(QJsonDocument json)
{
    QJsonObject data = json.object();
    return UserModel::fromJson(data);
}

bool UserModel::fromJson(QJsonObject json)
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

    emit resourceChanged();
    emit userChanged();
    return true;
}

void UserModel::clear()
{
    mId = 0;
    mFirstname = tr("Anonymous");
    mLastname = tr("Anonymous");
    mEmail = "";
    mLogin = "";
    mPassword = "";
    // TODO : mAvatar; empty qpixmap ?
    mFunction = "";
    mLocation = "";
    mRoles.clear();

    emit resourceChanged();
    emit userChanged();
}



bool UserModel::isAdmin()
{
    return mRoles.contains(Administration) && mRoles[Administration] == Write;
}


UserRight UserModel::role(const UserRole& role)
{
    return mRoles.contains(role) ? mRoles[role] : None;
}
void UserModel::setRole(const UserRole& role, const UserRight& right)
{
    mRoles[role] = right;
    emit resourceChanged();
    emit userChanged();
}
void UserModel::setRole(const QString& role, const QString& right)
{
    // TODO
}

void UserModel::save()
{
    if (isValid())
    {
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
        QHttpPart p1;
        p1.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"firstname\""));
        p1.setBody(mFirstname.toUtf8());
        QHttpPart p2;
        p2.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"lastname\""));
        p2.setBody(mLastname.toUtf8());
        QHttpPart p3;
        p3.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"email\""));
        p3.setBody(mEmail.toUtf8());
        QHttpPart p4;
        p4.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"function\""));
        p4.setBody(mFunction.toUtf8());
        QHttpPart p5;
        p5.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"location\""));
        p5.setBody(mLocation.toUtf8());

        multiPart->append(p1);
        multiPart->append(p2);
        multiPart->append(p3);
        multiPart->append(p4);
        multiPart->append(p5);


        Request* saveRequest = Request::put(QString("/users/%1").arg(mId), multiPart);
        connect(saveRequest, &Request::responseReceived, [this, multiPart, saveRequest](bool success, const QJsonObject& json)
        {
            if (success)
            {
                qDebug() << Q_FUNC_INFO << "User saved";
            }
            else
            {
                qCritical() << Q_FUNC_INFO << "Request error occured";
            }
            multiPart->deleteLater();
            saveRequest->deleteLater();
        });
    }
    else
    {
        qDebug() << Q_FUNC_INFO << "User not valid. Not able to save it on the server";
    }
}









// Properties ========================================


// Property : Lastname
const QString& UserModel::lastname() const
{
    return mLastname;
}
void UserModel::setLastname(const QString& lastname)
{
    mLastname = lastname;
    emit resourceChanged();
    emit userChanged();
}


// Property : Firstname
const QString& UserModel::firstname() const
{
    return mFirstname;
}
void UserModel::setFirstname(const QString& firstname)
{
    mFirstname = firstname;
    emit resourceChanged();
    emit userChanged();
}


// Property : Email
const QString& UserModel::email() const
{
    return mEmail;
}
void UserModel::setEmail(const QString& email)
{
    mEmail = email;
    emit resourceChanged();
    emit userChanged();
}


// Property : Login
const QString& UserModel::login() const
{
    return mLogin;
}
void UserModel::setLogin(const QString& login)
{
    mLogin = login;
    emit resourceChanged();
    emit userChanged();
}


// Property : Password
const QString& UserModel::password() const
{
    return mPassword;
}
void UserModel::setPassword(const QString& password)
{
    mPassword = password;
    emit resourceChanged();
    emit userChanged();
}


// Property : Avatar
const QPixmap& UserModel::avatar() const
{
    return mAvatar;
}
void UserModel::setAvatar(const QPixmap& avatar)
{
    mAvatar = avatar;
    emit resourceChanged();
    emit userChanged();
}


// Property : Function
const QString& UserModel::function() const
{
    return mFunction;
}
void UserModel::setFunction(const QString& function)
{
    mFunction = function;
    emit resourceChanged();
    emit userChanged();

}


// Property : Location
const QString& UserModel::location() const
{
    return mLocation;
}
void UserModel::setLocation(const QString& location)
{
    mLocation = location;
    emit resourceChanged();
    emit userChanged();
}


// Property : LastActivity
const QDate& UserModel::lastActivity() const
{
    return mLastActivity;
}
void UserModel::setLastActivity(const QDate& lastActivity)
{
    mLastActivity = lastActivity;
    emit resourceChanged();
    emit userChanged();
}


