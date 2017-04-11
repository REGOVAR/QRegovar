#ifndef PROJECTMODEL_H
#define PROJECTMODEL_H

#include <QtCore>

#include "resourcemodel.h"

/*!
 * \brief Define a Regovar project.
 */

enum ProjectStatus
{
    opened,
    closed,
    idle
};

class ProjectModel : public ResourceModel
{
    Q_OBJECT
public:
//    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY userChanged)
//    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY userChanged)

    // Constructors
    ProjectModel(QObject* parent=0);

    // Properties
    // Read
    const QString& name() const;
    const QString& comment() const;
    const QString& sharing() const;
    const QList<QString[3]>* events() const;
    const QList<QString[3]>* subjects() const;
    const QList<QString[3]>* analyses() const;
    const QList<QString[3]>* attachments() const;
    const ProjectStatus& status() const;
    const QDate& lastActivity() const;
    // Write
    void setName(const QString& name);
    void setComment(const QString& comment);
    void setSharing(const QString& sharing);
    void setEvents(QList<QString[3]>* events);
    void setSubjects(QList<QString[3]>* subjects);
    void setAnalyses(QList<QString[3]>* analyses);
    void setAttachments(QList<QString[3]>* attachments);
    void setStatus(const ProjectStatus& status);
    void setLastActivity(const QDate& lastActivity);

protected:
    QString mName;
    QString mComment;
    QString mSharing;
    QList<QString[3]>* mEvents;
    QList<QString[3]>* mSubjects;
    QList<QString[3]>* mAnalyses;
    QList<QString[3]>* mAttachments;
    ProjectStatus mStatus;
    QDate mLastActivity;



};

#endif // PROJECTMODEL_H
