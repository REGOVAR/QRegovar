#include "quickfiltermodel.h"
#include <QDebug>
#include <QJsonArray>

#include "transmissionquickfilter.h"
#include "positionquickfilter.h"
#include "qualityquickfilter.h"
#include "typequickfilter.h"
#include "frequencequickfilter.h"
#include "insilicopredquickfilter.h"
#include "phenotypequickfilter.h"
#include "panelquickfilter.h"


QuickFilterModel::QuickFilterModel(QObject *parent) : QObject(parent)
{
}

void QuickFilterModel::init(int refId, int)
{
    mQuickFilters.clear();
    // Load filter according to the refID, analysisId
    mQuickFilters[TransmissionFilter] = new TransmissionQuickFilter(refId);
    mQuickFilters[QualityFilter] = new QualityQuickFilter(refId);
    mQuickFilters[PositionFilter] = new PositionQuickFilter(refId);
    mQuickFilters[TypeFilter] = new TypeQuickFilter(refId);
    mQuickFilters[FrequenceFilter] = new FrequenceQuickFilter(refId);
    mQuickFilters[InSilicoPredFilter] = new InSilicoPredQuickFilter(refId);
    //mQuickFilters[PanelFilter] = new PanelQuickFilter(refId);
    mQuickFilters[PhenotypeFilter] = new PhenotypeQuickFilter(refId);
}




QJsonArray QuickFilterModel::toJson()
{
    QJsonArray filters;
    for (QuickFilterBlockInterface* filter: mQuickFilters.values())
    {
        if (filter->isVisible())
        {
            QJsonArray f = filter->toJson();
            if (!f.isEmpty())
            {
                if (f[0].toString() == "AND")
                {
                    for (const QJsonValue& val: f[1].toArray())
                    {
                        filters.append(val.toArray());
                    }
                }
                else
                {
                    filters.append(f);
                }
            }
        }
    }

    if (filters.count() == 1 && filters[0].isArray())
    {
        QJsonArray oneFilter = filters[0].toArray();
        if (oneFilter[0] == "AND" || oneFilter[0] == "OR")
            return oneFilter;
    }

    QJsonArray result;
    result.append("AND");
    result.append(filters);
    return result;
}

void QuickFilterModel::checkAnnotationsDB(QList<QObject*> dbs)
{
    mQuickFilters[TransmissionFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[QualityFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[PositionFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[TypeFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[FrequenceFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[InSilicoPredFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[PhenotypeFilter]->checkAnnotationsDB(dbs);
}

void QuickFilterModel::loadFilter(QJsonArray json)
{
    for (QuickFilterBlockInterface* filter: mQuickFilters.values())
    {
        filter->loadJson(json);
    }
}


void QuickFilterModel::clear()
{
    for (QuickFilterBlockInterface* filter: mQuickFilters.values())
    {
        filter->clear();
    }
}




