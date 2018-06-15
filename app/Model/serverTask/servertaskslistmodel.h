#ifndef SERVERTASKSLISTMODEL_H
#define SERVERTASKSLISTMODEL_H

#include <QtCore>
#include "servertask.h"
#include "Model/framework/genericproxymodel.h"


class ServerTasksListModel : public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Status,
        Progress,
        Label,
        UpdateDate,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructors
    ServerTasksListModel(QObject* parent = nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    ServerTask* getOrCreateTask(QString action, QJsonObject data);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();

private:
    //! List of events
    QList<ServerTask*> mServerTaskList;

    QHash<QString, ServerTask*> mServerTaskMap;
    //! The QSortFilterProxyModel to use by table view to browse tasks of the list
    GenericProxyModel* mProxy = nullptr;
};

#endif // SERVERTASKSLISTMODEL_H
