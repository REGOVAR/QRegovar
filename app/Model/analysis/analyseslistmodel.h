#ifndef ANALYSESLISTMODEL_H
#define ANALYSESLISTMODEL_H

#include <QtCore>
#include "Model/framework/genericproxymodel.h"

class Analysis;
class AnalysesListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Name,
        FullPathName,
        Comment,
        Type,
        Project,
        Status,
        UpdateDate,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    AnalysesListModel(QObject* parent = nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Clear list and load entries from json data
    Q_INVOKABLE bool loadJson(const QJsonArray& json);
    //! Add the provided analysis to the list if not already contains
    Q_INVOKABLE bool append(Analysis* analysis);
    //! Remove an analysis from the list if possible
    Q_INVOKABLE bool remove(Analysis* analysis);
    //! Return entry at the requested position; nullptr if not exists
    Q_INVOKABLE Analysis* getAt(int idx);

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
    //! List of analyses
    QList<Analysis*> mAnalyses;
    //! The QSortFilterProxyModel to use by table view to browse subject of the manager
    GenericProxyModel* mProxy = nullptr;
};

#endif // ANALYSESLISTMODEL_H
