#include "projectmodel.h"

ProjectModel::ProjectModel(QObject* parent)
    : ResourceModel(parent)
{
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
const QList<QString[3]>* ProjectModel::events() const
{
    return mEvents;
}
void ProjectModel::setEvents(QList<QString[3]>* events)
{
    mEvents = events;
    emit resourceChanged();
}


// Property : Subjects
const QList<QString[3]>* ProjectModel::subjects() const
{
    return mSubjects;
}
void ProjectModel::setSubjects(QList<QString[3]>* subjects)
{
    mSubjects = subjects;
    emit resourceChanged();
}


// Property : Analyses
const QList<QString[3]>* ProjectModel::analyses() const
{
    return mAnalyses;
}
void ProjectModel::setAnalyses(QList<QString[3]>* analyses)
{
    mAnalyses = analyses;
    emit resourceChanged();
}


// Property : Attachments
const QList<QString[3]>* ProjectModel::attachments() const
{
    return mAttachments;
}
void ProjectModel::setAttachments(QList<QString[3]>* attachments)
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
const QDate& ProjectModel::lastActivity() const
{
    return mLastActivity;
}
void ProjectModel::setLastActivity(const QDate& lastActivity)
{
    mLastActivity = lastActivity;
    emit resourceChanged();
}



