#ifndef PROJECTMODEL_H
#define PROJECTMODEL_H

#include <QtCore>

#include "resourcemodel.h"
#include "eventmodel.h"


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
    const ProjectStatus& status() const;
    const QDateTime& lastActivity() const;
    // Write
    void setName(const QString& name);
    void setComment(const QString& comment);
    void setSharing(const QString& sharing);
    void setStatus(const ProjectStatus& status);
    void setLastActivity(const QDateTime& lastActivity);

    // Methods to override
    bool fromJson(QJsonDocument json);
    void clear();

    QList<EventModel*>* getEventsList();

protected:
    QString mName;
    QString mComment;
    QString mSharing;
    ProjectStatus mStatus;
    QDateTime mLastActivity;

};

#endif // PROJECTMODEL_H
