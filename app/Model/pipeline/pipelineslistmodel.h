#ifndef PIPELINESLISTMODEL_H
#define PIPELINESLISTMODEL_H

#include <QtCore>
#include "pipeline.h"
#include "Model/framework/genericproxymodel.h"

class PipelinesListModel : public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Name,
        Description,
        Version,
        Type,
        Status,
        Starred,
        Authors,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructor
    PipelinesListModel(QObject* parent=nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    Q_INVOKABLE bool loadJson(const QJsonArray& json);
    Q_INVOKABLE bool append(Pipeline* pipe);
    Q_INVOKABLE bool remove(Pipeline* pipe);
    Q_INVOKABLE Pipeline* getAt(int position);
    Q_INVOKABLE bool refresh();

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();


public Q_SLOTS:
    void propagateDataChanged();


private:
    //! List of pipelines
    QList<Pipeline*> mPipelines;
    //! The QSortFilterProxyModel to use by table view to browse samples of the manager
    GenericProxyModel* mProxy = nullptr;
    //! Last time that the list have been updated
    QDateTime mLastUpdate;
};

#endif // PIPELINESLISTMODEL_H
