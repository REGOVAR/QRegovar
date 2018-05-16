#include "user.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

User::User(QObject* parent) : QObject(parent)
{
    connect(this, &User::dataChanged, this, &User::updateSearchField);
}

User::User(int id, QObject* parent): User(parent)
{
    mId = id;
}
User::User(int id, const QString& firstname, const QString& lastname, QObject* parent): User(parent)
{
    mId = id;
    mFirstname = firstname;
    mLastname = lastname;
}


void User::updateSearchField()
{
    mSearchField = mLogin + " " + mFirstname + " " + mLastname + " " + mEmail + " " + mFunction + " " + mLocation;
    mSearchField +=  " " + (mIsAdmin ? tr("admin") : "") + (mIsActive ? tr("active") : "");
}


bool User::loadJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mLogin = json["login"].toString();
    mFirstname = json["firstname"].toString();
    mLastname = json["lastname"].toString();
    mEmail = json["email"].toString();
    mFunction = json["function"].toString();
    mLocation = json["location"].toString();
    mCreationDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mLastActivity = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);
    mIsActive = json["is_active"].toBool();
    mIsAdmin = json["is_admin"].toBool();
    qDebug() << Q_FUNC_INFO << "New User" << mId << mFirstname << mLastname;

    emit dataChanged();
    return true;
}

QJsonObject User::toJson(bool withPassword)
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("login", mLogin);
    result.insert("firstname", mFirstname);
    result.insert("lastname", mLastname);
    result.insert("email", mEmail);
    result.insert("function", mFunction);
    result.insert("location", mLocation);
    result.insert("is_active", mIsActive);
    result.insert("is_admin", mIsAdmin);

    if (withPassword)
    {
        result.insert("password", mPassword);
    }
    return result;
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
    emit dataChanged();
}


bool User::isValid()
{
    return mId > 0;
}



void User::save(bool withPassword)
{
    if (mLogin.isEmpty())
    {
        regovar->manageClientError("User's login is empty, not able to save it.", "", Q_FUNC_INFO);
        return;
    }

    Request* request;
    if (mId <= 0)
    {
        request = Request::post("/user", QJsonDocument(toJson(withPassword)).toJson());
    }
    else
    {
        request = Request::put(QString("/user/%1").arg(mId), QJsonDocument(toJson(withPassword)).toJson());
    }

    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (!success)
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        request->deleteLater();
    });
}



void User::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/user/%1").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                loadJson(json["data"].toObject());
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}





