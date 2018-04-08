#ifndef PHENOTYPESLISTMODEL_H
#define PHENOTYPESLISTMODEL_H

#include <QtCore>
#include "phenotype.h"
#include "Model/framework/genericproxymodel.h"

class Phenotype;
class PhenotypesListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Label,
        Definition,
        Parent,
        Childs,
        Diseases,
        Genes,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructor
    explicit PhenotypesListModel(QObject* parent=nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Load phenotype list from json
    Q_INVOKABLE bool fromJson(QJsonArray json);
    //! Add the provided phenotype to the list if not already contains
    Q_INVOKABLE bool add(Phenotype* phenotype);
    //! Remove a phenotype from the list if possible
    Q_INVOKABLE bool remove(Phenotype* phenotype);
    //! Return entry at the requested position in the list
    Q_INVOKABLE Phenotype* getAt(int idx);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();


private:
    QList<Phenotype*> mPhenotypes;
    GenericProxyModel* mProxy = nullptr;
};

#endif // PHENOTYPESLISTMODEL_H
