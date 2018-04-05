#ifndef PHENOTYPESMANAGER_H
#define PHENOTYPESMANAGER_H

#include <QtCore>
#include "phenotype.h"

class PhenotypesManager : public QObject
{
    Q_OBJECT
public:
    // Constructor
    explicit PhenotypesManager(QObject *parent = nullptr);

    // Methods
    Q_INVOKABLE void fromJson(QJsonArray json);
    Q_INVOKABLE void search(QString query);

Q_SIGNALS:
    void phenotypeSearchDone(bool success, QJsonArray result);

private:

    QHash<QString, Phenotype*> mPhenotypes;
    QHash<QString, QString> mPhenotypesSearchMap;
};

#endif // PHENOTYPESMANAGER_H
