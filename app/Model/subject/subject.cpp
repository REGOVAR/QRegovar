#include "subject.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

Subject::Subject(QObject* parent) : QObject(parent)
{
}

Subject::Subject(QJsonObject json, QObject* parent) : QObject(parent)
{
    fromJson(json);
}
Subject::Subject(int id, QObject* parent) : QObject(parent)
{
    mId = id;
    load();
}



bool Subject::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mIdentifier = json["identifier"].toString();
    mFirstname = json["firstname"].toString();
    mLastname = json["lastname"].toString();
    mComment = json["comment"].toString();
    mFamilyNumber = json["family_number"].toString();
    QString sex = json["sex"].toString();
    mSex = sex == "male" ? Sex::Male : "female" ?  Sex::Female : Sex::Unknow;
    mDateOfBirth = QDateTime::fromString(json["date_of_birth"].toString());
    // mDateOfDeath = QDateTime::fromString(json["date_of_death"].toString()); // not used
    mUpdated = QDateTime::fromString(json["update_date"].toString());
    mCreated = QDateTime::fromString(json["create_date"].toString());

    mSamples.clear();
    mAnalyses.clear();
    mProjects.clear();
    mJobs.clear();
    mFiles.clear();
    mIndicators.clear();
    return true;
}


QJsonObject Subject::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("identifier", mId);
    result.insert("firstname", mFirstname);
    result.insert("lastname", mLastname);
    result.insert("date_of_birth", mDateOfBirth.toString(Qt::ISODate));
    result.insert("family_number", mFamilyNumber);
    result.insert("comment", mComment);
    result.insert("sex", mSex == Sex::Male ? "male" : mSex == Sex::Female ? "female" : "unknow");
    // Samples
    // Files
    // Indicators

    return result;
}


void Subject::save()
{
    QJsonObject body = toJson();

    Request* request = Request::put(QString("/subject/%1").arg(mId), QJsonDocument(body).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Subject saved";
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        request->deleteLater();
    });
}


void Subject::load()
{
    Request* req = Request::get(QString("/subject/%1").arg(mId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            fromJson(json["data"].toObject());
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
