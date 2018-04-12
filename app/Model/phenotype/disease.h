#ifndef DISEASE_H
#define DISEASE_H

#include <QtCore>
#include "hpodata.h"
#include "phenotypeslistmodel.h"

class PhenotypesListModel;
class Disease: public HpoData
{
    Q_OBJECT
    Q_PROPERTY(QStringList genes READ genes NOTIFY dataChanged)


public:
    // Constructor
    explicit Disease(QObject* parent = nullptr);
    explicit Disease(QString hpoId, QObject* parent = nullptr);

    // Getters
    inline QStringList genes() const { return mGenes; }

    // Method
    PhenotypesListModel* getQualifiers(QString hpoId);

    // HpoData abstracts methods overriden
    Q_INVOKABLE bool fromJson(QJsonObject json);


public Q_SLOTS:
    virtual void updateSearchField();


private:
    QStringList mGenes;
};

#endif // DISEASE_H
