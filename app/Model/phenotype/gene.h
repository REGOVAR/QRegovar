#ifndef GENE_H
#define GENE_H

#include <QtCore>
#include "Model/framework/regovarresource.h"

class Gene: public RegovarResource
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString symbol READ symbol NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject json READ json NOTIFY dataChanged)


public:
    // Constructor
    Gene(QObject* parent=nullptr);
    Gene(QJsonObject json, QObject* parent=nullptr);
    Gene(QString symbol, QObject* parent=nullptr);

    // Getters
    inline QString id() const { return mHgncId; }
    inline QString symbol() const { return mSymbol; }
    inline QJsonObject json() const { return mJson; }

    // Override ressource methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Load resource information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;


public Q_SLOTS:
    void updateSearchField() override;

private:
    QString mHgncId;
    QString mSymbol;
    QJsonObject mJson;
};

#endif // GENE_H
