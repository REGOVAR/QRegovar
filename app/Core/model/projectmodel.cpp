#include "projectmodel.h"

ProjectModel::ProjectModel() : ResourceModel()
{
    mName = "Toto prj";
    mComment = "Il s'agit du project de la famille Toto";
    mSharing = "GUEUDELOT Olivier, SCHUTZ Sacha";
    mEvents = new QList<QString>();
    mSubjects = new QList<QString>();
    mAnalyses = new QList<QString>();
    mAttachments = new QList<QString>();
    mStatus = Opened;
    mLastActivity = QDateTime::currentDateTime();
}














bool ProjectModel::fromJson(QJsonDocument json)
{

}

void ProjectModel::clear()
{
    delete mEvents;
    delete mSubjects;
    delete mAnalyses;
    delete mAttachments;
}













// Property : Name
const QString& ProjectModel::name() const
{
    return mName;
}
void ProjectModel::setName(const QString& name)
{
    mName = name;
    emit resourceChanged();
}


// Property : Comment
const QString& ProjectModel::comment() const
{
    return mComment;
}
void ProjectModel::setComment(const QString& comment)
{
    mComment = comment;
    emit resourceChanged();
}


// Property : Sharing
const QString& ProjectModel::sharing() const
{
    return mSharing;
}
void ProjectModel::setSharing(const QString& sharing)
{
    mSharing = sharing;
    emit resourceChanged();
}


// Property : Events
const QList<QString>* ProjectModel::events() const
{
    return mEvents;
}
void ProjectModel::setEvents(QList<QString>* events)
{
    mEvents = events;
    emit resourceChanged();
}


// Property : Subjects
const QList<QString>* ProjectModel::subjects() const
{
    return mSubjects;
}
void ProjectModel::setSubjects(QList<QString>* subjects)
{
    mSubjects = subjects;
    emit resourceChanged();
}


// Property : Analyses
const QList<QString>* ProjectModel::analyses() const
{
    return mAnalyses;
}
void ProjectModel::setAnalyses(QList<QString>* analyses)
{
    mAnalyses = analyses;
    emit resourceChanged();
}


// Property : Attachments
const QList<QString>* ProjectModel::attachments() const
{
    return mAttachments;
}
void ProjectModel::setAttachments(QList<QString>* attachments)
{
    mAttachments = attachments;
    emit resourceChanged();
}


// Property : Status
const ProjectStatus& ProjectModel::status() const
{
    return mStatus;
}
void ProjectModel::setStatus(const ProjectStatus& status)
{
    mStatus = status;
    emit resourceChanged();
}


// Property : LastActivity
const QDateTime& ProjectModel::lastActivity() const
{
    return mLastActivity;
}
void ProjectModel::setLastActivity(const QDateTime& lastActivity)
{
    mLastActivity = lastActivity;
    emit resourceChanged();
}



