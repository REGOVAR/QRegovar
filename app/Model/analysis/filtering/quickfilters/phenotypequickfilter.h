#ifndef PHENOTYPEQUICKFILTER_H
#define PHENOTYPEQUICKFILTER_H

#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"
#include "Model/phenotype/hpodatalistmodel.h"


class PhenotypeQuickFilter: public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(HpoDataListModel* hpoList READ hpoList)

public:
    // Constructors
    PhenotypeQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible() override;
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant()) override;
    Q_INVOKABLE void clear() override;
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs) override;
    bool loadJson(QJsonArray filter) override;

    inline HpoDataListModel* hpoList() { return mHpoList; }
    void init(QString _1000gUid, QString exacUid, QStringList _1000g, QStringList exac);


private:
    HpoDataListModel* mHpoList = nullptr;
    QString mFilter;
    QStringList mOperators;
    QHash<QString, QString> mOpMapping;

    QHash<QString,QString> mFieldsNames;
};

#endif // PHENOTYPEQUICKFILTER_H
