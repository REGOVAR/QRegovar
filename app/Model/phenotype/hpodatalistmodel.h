#ifndef HPODATALISTMODEL_H
#define HPODATALISTMODEL_H

#include <QtCore>
#include "hpodata.h"
#include "Model/framework/genericproxymodel.h"
#include "Model/subject/subject.h"

class Subject;
class HpoDataListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Label,
        Type,
        Category,
        Presence,
        AdditionDate,
        DiseasesFreq,
        GenesFreq,
        Genes,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(Subject* subject READ subject NOTIFY neverChanged)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructor
    explicit HpoDataListModel(QObject* parent=nullptr);
    explicit HpoDataListModel(int subjectId, QObject* parent=nullptr);

    // Getters
    Subject* subject() const;
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Load phenotype list from json
    Q_INVOKABLE bool fromJson(QJsonArray json);
    //! Add the provided phenotype to the list if not already contains
    Q_INVOKABLE bool add(HpoData* hpoData);
    //! Remove a phenotype from the list if possible
    Q_INVOKABLE bool remove(HpoData* hpoData);
    //! Return entry at the requested position in the list
    Q_INVOKABLE HpoData* getAt(int idx);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();


private:
    int mSubjectId = -1;

    QList<HpoData*> mHpoDataList;
    GenericProxyModel* mProxy = nullptr;
};

#endif // HPODATALISTMODEL_H
