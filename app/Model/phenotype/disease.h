#ifndef DISEASE_H
#define DISEASE_H

#include <QtCore>
#include "hpodata.h"
#include "phenotypeslistmodel.h"

class Disease: public HpoData
{
    Q_OBJECT
    Q_PROPERTY(QJsonObject omim READ omim  NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject orpha READ orpha  NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject decipher READ decipher  NOTIFY dataChanged)
    Q_PROPERTY(PhenotypesListModel* phenotypes READ phenotypes NOTIFY dataChanged)


public:
    // Constructor
    Disease(QObject* parent = nullptr);
    Disease(QString hpoId, QObject* parent = nullptr);

    // Getters
    inline QJsonObject omim() const { return mOmim; }
    inline QJsonObject orpha() const { return mOrpha; }
    inline QJsonObject decipher() const { return mDecipher; }
    inline PhenotypesListModel* phenotypes() const { return mPhenotypes; }


    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(const QJsonObject& json, bool full_init=true) override;


public Q_SLOTS:
    void updateSearchField() override;


private:
    QJsonObject mOmim;
    QJsonObject mOrpha;
    QJsonObject mDecipher;
    PhenotypesListModel* mPhenotypes = nullptr;
};

#endif // DISEASE_H
