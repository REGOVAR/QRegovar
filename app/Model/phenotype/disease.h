#ifndef DISEASE_H
#define DISEASE_H

#include <QtCore>
#include "hpodata.h"

class Disease: public HpoData
{
    Q_OBJECT
    Q_PROPERTY(QJsonObject omim READ omim  NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject orpha READ orpha  NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject decipher READ decipher  NOTIFY dataChanged)


public:
    // Constructor
    explicit Disease(QObject* parent = nullptr);
    explicit Disease(QString hpoId, QObject* parent = nullptr);

    // Getters
    inline QJsonObject omim() const { return mOmim; }
    inline QJsonObject orpha() const { return mOrpha; }
    inline QJsonObject decipher() const { return mDecipher; }


    // HpoData abstracts methods overriden
    Q_INVOKABLE bool loadJson(QJsonObject json);


public Q_SLOTS:
    virtual void updateSearchField();


private:
    QJsonObject mOmim;
    QJsonObject mOrpha;
    QJsonObject mDecipher;
};

#endif // DISEASE_H
