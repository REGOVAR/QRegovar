#ifndef EVENTSLISTMODEL_H
#define EVENTSLISTMODEL_H

#include <QtCore>
#include "event.h"
#include "Model/framework/genericproxymodel.h"

class EventsListModel : public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Message,
        Details,
        Type,
        Date,
        Author,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)
    Q_PROPERTY(QString target READ target NOTIFY neverChanged)
    Q_PROPERTY(QString id READ id NOTIFY neverChanged)

public:
    explicit EventsListModel(QObject* parent = nullptr);
    explicit EventsListModel(QString target, QString id, QObject* parent = nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }
    inline QString target() const { return mTarget; }
    inline QString id() const { return mId; }

    // Methods
    bool loadJson(QJsonArray json);
    bool add(Event* event);
    bool refresh();

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();

private:
    //! The id of the current referencial (update sample list on change)
    int mRefId = -1;
    //! List of events
    QList<Event*> mEventList;
    //! The QSortFilterProxyModel to use by table view to browse samples of the manager
    GenericProxyModel* mProxy = nullptr;
    //! Target concerned by events model
    QString mTarget;
    QString mId;
    QDateTime mLastUpdate;
};

#endif // EVENTSLISTMODEL_H
