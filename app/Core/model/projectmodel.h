#ifndef PROJECTMODEL_H
#define PROJECTMODEL_H

#include <QtCore>

#include "resourcemodel.h"



enum ProjectStatus
{
    Opened,
    Closed,
    Idle
};

/*!
 * \brief Define a Regovar project.
 */
class ProjectModel : public ResourceModel
{
    Q_OBJECT
public:

    // Constructors
    ProjectModel();

    // Properties
    // Read
    const QString& name() const;
    const QString& comment() const;
    const QString& sharing() const;
    const QList<QString>* events() const;
    const QList<QString>* subjects() const;
    const QList<QString>* analyses() const;
    const QList<QString>* attachments() const;
    const ProjectStatus& status() const;
    const QDateTime& lastActivity() const;
    // Write
    void setName(const QString& name);
    void setComment(const QString& comment);
    void setSharing(const QString& sharing);
    void setEvents(QList<QString>* events);
    void setSubjects(QList<QString>* subjects);
    void setAnalyses(QList<QString>* analyses);
    void setAttachments(QList<QString>* attachments);
    void setStatus(const ProjectStatus& status);
    void setLastActivity(const QDateTime& lastActivity);

    // Methods to override
    bool fromJson(QJsonDocument json);
    void clear();


protected:
    QString mName;
    QString mComment;
    QString mSharing;
    QList<QString>* mEvents;
    QList<QString>* mSubjects;
    QList<QString>* mAnalyses;
    QList<QString>* mAttachments;
    ProjectStatus mStatus;
    QDateTime mLastActivity;



};

#endif // PROJECTMODEL_H
