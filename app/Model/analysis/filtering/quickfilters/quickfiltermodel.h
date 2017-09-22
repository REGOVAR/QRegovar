#ifndef QUICKFILTERMODEL_H
#define QUICKFILTERMODEL_H

#include <QObject>
#include <QHash>
#include <QVariant>
#include "quickfilterblockinterface.h"
#include "Model/analysis/filtering/annotation.h"


class QuickFilterModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QuickFilterBlockInterface* transmissionFilter READ transmissionFilter NOTIFY filterUpdated)
    Q_PROPERTY(QuickFilterBlockInterface* qualityFilter READ qualityFilter NOTIFY filterUpdated)
    Q_PROPERTY(QuickFilterBlockInterface* positionFilter READ positionFilter NOTIFY filterUpdated)
    Q_PROPERTY(QuickFilterBlockInterface* typeFilter READ typeFilter NOTIFY filterUpdated)
    Q_PROPERTY(QuickFilterBlockInterface* frequenceFilter READ frequenceFilter NOTIFY filterUpdated)
    Q_PROPERTY(QuickFilterBlockInterface* inSilicoPredFilter READ inSilicoPredFilter NOTIFY filterUpdated)


public:
    enum PredefinedFilter
    {
        TransmissionFilter,
        QualityFilter,
        PositionFilter,
        TypeFilter,
        FrequenceFilter,
        InSilicoPredFilter
    };

    explicit QuickFilterModel(QObject *parent = nullptr);
    void init(int refId, int analysisId);
    Q_INVOKABLE void clear();


    // Getters
    inline QuickFilterBlockInterface* transmissionFilter() { return mQuickFilters[TransmissionFilter]; }
    inline QuickFilterBlockInterface* qualityFilter() { return mQuickFilters[QualityFilter]; }
    inline QuickFilterBlockInterface* positionFilter() { return mQuickFilters[PositionFilter]; }
    inline QuickFilterBlockInterface* typeFilter() { return mQuickFilters[TypeFilter]; }
    inline QuickFilterBlockInterface* frequenceFilter() { return mQuickFilters[FrequenceFilter]; }
    inline QuickFilterBlockInterface* inSilicoPredFilter() { return mQuickFilters[InSilicoPredFilter]; }


    // Methods
    Q_INVOKABLE QString getFilter();
    Q_INVOKABLE QString checkAnnotationsDB(QList<QObject*> dbs);
    void loadFilter(QJsonArray filter);

Q_SIGNALS:
    void filterUpdated();



private:
    QHash<PredefinedFilter, QuickFilterBlockInterface*> mQuickFilters;
};

#endif // QUICKFILTERMODEL_H
