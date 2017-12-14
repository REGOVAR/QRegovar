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

    Q_PROPERTY(QuickFilterBlockInterface* transmissionFilter READ transmissionFilter NOTIFY filterChanged)
    Q_PROPERTY(QuickFilterBlockInterface* qualityFilter READ qualityFilter NOTIFY filterChanged)
    Q_PROPERTY(QuickFilterBlockInterface* positionFilter READ positionFilter NOTIFY filterChanged)
    Q_PROPERTY(QuickFilterBlockInterface* typeFilter READ typeFilter NOTIFY filterChanged)
    Q_PROPERTY(QuickFilterBlockInterface* frequenceFilter READ frequenceFilter NOTIFY filterChanged)
    Q_PROPERTY(QuickFilterBlockInterface* inSilicoPredFilter READ inSilicoPredFilter NOTIFY filterChanged)
    Q_PROPERTY(QuickFilterBlockInterface* panelFilter READ panelFilter NOTIFY filterChanged)
    Q_PROPERTY(QuickFilterBlockInterface* phenotypeFilter READ phenotypeFilter NOTIFY filterChanged)


public:
    enum PredefinedFilter
    {
        TransmissionFilter,
        QualityFilter,
        PositionFilter,
        TypeFilter,
        FrequenceFilter,
        InSilicoPredFilter,
        PanelFilter,
        PhenotypeFilter
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
    inline QuickFilterBlockInterface* panelFilter() { return mQuickFilters[PanelFilter]; }
    inline QuickFilterBlockInterface* phenotypeFilter() { return mQuickFilters[PhenotypeFilter]; }


    // Methods
    Q_INVOKABLE QJsonArray toJson();
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs);
    void loadFilter(QJsonArray filter);

Q_SIGNALS:
    void filterChanged();



private:
    QHash<PredefinedFilter, QuickFilterBlockInterface*> mQuickFilters;
};

#endif // QUICKFILTERMODEL_H
