#ifndef GENE_H
#define GENE_H

#include <QtCore>
#include "Model/framework/regovarresource.h"
#include "Model/framework/jsonlistmodel.h"
#include "phenotypeslistmodel.h"
#include "diseaseslistmodel.h"
#include "Model/panel/panelslistmodel.h"

class Gene: public RegovarResource
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString symbol READ symbol NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject json READ json NOTIFY dataChanged)
    Q_PROPERTY(PhenotypesListModel* phenotypes READ phenotypes NOTIFY dataChanged)
    Q_PROPERTY(DiseasesListModel* diseases READ diseases NOTIFY dataChanged)
    Q_PROPERTY(JsonListModel* pubmed READ pubmed NOTIFY dataChanged)
    Q_PROPERTY(PanelsListModel* panels READ panels NOTIFY dataChanged)



public:
    // Constructor
    Gene(QObject* parent=nullptr);
    Gene(QJsonObject json, QObject* parent=nullptr);
    Gene(QString symbol, QObject* parent=nullptr);

    // Getters
    inline QString id() const { return mHgncId; }
    inline QString symbol() const { return mSymbol; }
    inline QJsonObject json() const { return mJson; }
    inline PhenotypesListModel* phenotypes() const { return mPhenotypes; }
    inline DiseasesListModel* diseases() const { return mDiseases; }
    inline JsonListModel* pubmed() const { return mPubmed; }
    inline PanelsListModel* panels() const { return mPanels; }

    // Override ressource methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(const QJsonObject& json, bool full_init=true) override;
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
    PhenotypesListModel* mPhenotypes = nullptr;
    DiseasesListModel* mDiseases = nullptr;
    JsonListModel* mPubmed = nullptr;
    PanelsListModel* mPanels = nullptr;
};

#endif // GENE_H
