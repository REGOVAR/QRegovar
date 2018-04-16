#ifndef DISEASESLISTMODEL_H
#define DISEASESLISTMODEL_H

#include <QtCore>
#include "disease.h"
#include "Model/framework/genericproxymodel.h"

class DiseasesListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Label,
        Qualifiers,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)
    Q_PROPERTY(QString phenotypeId READ phenotypeId NOTIFY neverChanged)

public:
    // Constructor
    explicit DiseasesListModel(QObject* parent=nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }
    inline QString phenotypeId() const { return mPhenotypeId; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Load phenotype list from json
    Q_INVOKABLE bool loadJson(QJsonArray json);
    //! Add the provided phenotype to the list if not already contains
    Q_INVOKABLE bool append(Disease* disease);
    //! Remove a phenotype from the list if possible
    Q_INVOKABLE bool remove(Disease* disease);
    //! Return entry at the requested position in the list
    Q_INVOKABLE Disease* getAt(int idx);
    //! Set the id of the related phenotype
    Q_INVOKABLE inline void setPhenotypeId(QString id) { mPhenotypeId = id; }

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();


private:
    QList<Disease*> mDiseases;
    QString mPhenotypeId;
    GenericProxyModel* mProxy = nullptr;
};

#endif // DISEASESLISTMODEL_H
