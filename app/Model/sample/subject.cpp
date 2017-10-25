#include "subject.h"

Subject::Subject(QObject* parent) : QObject(parent)
{
}

Subject::Subject(QJsonObject json, QObject* parent) : QObject(parent)
{
    fromJson(json);
}



bool Subject::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mIdentifier = json["identifier"].toString();
    mFirstname = json["firstname"].toString();
    mLastname = json["lastname"].toString();
    mComment = json["comment"].toString();
    QString sex = json["sex"].toString();
    mSex = sex == "male" ? Sex::Male : "female" ?  Sex::Female : Sex::Unknow;
    mDateOfBirth = QDateTime::fromString(json["date_of_birth"].toString());
    mDateOfDeath = QDateTime::fromString(json["date_of_death"].toString());
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

}
