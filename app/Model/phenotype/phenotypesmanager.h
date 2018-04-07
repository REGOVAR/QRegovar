#ifndef PHENOTYPESMANAGER_H
#define PHENOTYPESMANAGER_H

#include <QtCore>
#include "phenotype.h"
#include "phenotypeslistmodel.h"

class PhenotypesManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PhenotypesListModel* searchResults READ searchResults NOTIFY searchDone)

public:
    // Constructor
    explicit PhenotypesManager(QObject* parent=nullptr);

    // Getters
    inline PhenotypesListModel* searchResults() const { return mSearchResults; }

    // Methods
    Q_INVOKABLE Phenotype* getOrCreatePhenotype(QString hpoId);
    Q_INVOKABLE Disease* getOrCreateDisease(QString hpoId);
    Q_INVOKABLE void search(QString query);


Q_SIGNALS:
    void searchDone(bool success);

private:
    PhenotypesListModel* mSearchResults = nullptr;
    QHash<QString, Phenotype*> mPhenotypes;
    QHash<QString, Disease*> mDiseases;
    QHash<QString, QString> mPhenotypesSearchMap;
};

#endif // PHENOTYPESMANAGER_H
