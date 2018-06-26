#ifndef SAMPLESLISTMODEL_H
#define SAMPLESLISTMODEL_H

#include <QtCore>
#include "Model/framework/genericproxymodel.h"
#include "sample.h"
#include "subject.h"

class Subject;
class Sample;
class SamplesListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Name,
        IsMosaic,
        Comment,
        Status,
        Source,
        Reference,
        UpdateDate,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructors
    SamplesListModel(QObject* parent = nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Clear list and load entries from json data
    Q_INVOKABLE bool loadJson(QJsonArray json);
    //! Add the provided sample to the list if not already contains
    Q_INVOKABLE bool append(Sample* subject);
    //! Remove a sample from the list if possible
    Q_INVOKABLE bool remove(Sample* subject);
    //! Return entry at the requested position; nullptr if not exists
    Q_INVOKABLE Sample* getAt(int idx);

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
    //! List of samples
    QList<Sample*> mSamples;
    //! The QSortFilterProxyModel to use by table view to browse samples
    GenericProxyModel* mProxy = nullptr;
};

#endif // SAMPLESLISTMODEL_H
