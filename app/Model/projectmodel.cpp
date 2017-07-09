#include "projectmodel.h"

ProjectModel::ProjectModel() : ResourceModel()
{
    mName = "Toto prj";
    mComment = "Il s'agit du project de la famille Toto";
    mSharing = "GUEUDELOT Olivier, SCHUTZ Sacha";
    mStatus = Opened;
    mLastActivity = QDateTime::currentDateTime();
}














bool ProjectModel::fromJson(QJsonDocument json)
{
    // TODO
    return false;
}

void ProjectModel::clear()
{
}





QList<EventModel*>* ProjectModel::getEventsList()
{
    QList<EventModel*>* eventsList = new QList<EventModel*>;

    // TODO : retrieve event from rest api
    // FIXME : fake data to debug
    eventsList->append(new EventModel(1, QDateTime::currentDateTime(), Info, "Coucou", nullptr));
    eventsList->append(new EventModel(2, QDateTime::currentDateTime(), Info, "Test", nullptr));
    eventsList->append(new EventModel(3, QDateTime::currentDateTime(), Warning, "Attention !", nullptr));
    eventsList->append(new EventModel(4, QDateTime::currentDateTime(), Success, "Yes :)", nullptr));

    return eventsList;
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



