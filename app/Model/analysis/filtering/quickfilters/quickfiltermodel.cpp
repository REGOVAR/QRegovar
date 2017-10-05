#include "quickfiltermodel.h"
#include <QDebug>
#include <QJsonArray>

#include "transmissionquickfilter.h"
#include "positionquickfilter.h"
#include "qualityquickfilter.h"
#include "typequickfilter.h"
#include "frequencequickfilter.h"
#include "insilicopredquickfilter.h"


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

}




QJsonArray QuickFilterModel::toJson()
{
    QJsonArray result;
    QJsonArray filters;
    result.append("AND");
    foreach (QuickFilterBlockInterface* filter, mQuickFilters.values())
    {
        if (filter->isVisible())
        {
            QJsonArray f = filter->toJson();
            if (!f.isEmpty())
            {
                filters.append(f);
            }
        }
    }
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
}

void QuickFilterModel::loadFilter(QJsonArray json)
{
    foreach (QuickFilterBlockInterface* filter, mQuickFilters.values())
    {
        filter->loadJson(json);
    }
}


void QuickFilterModel::clear()
{
    foreach (QuickFilterBlockInterface* filter, mQuickFilters.values())
    {
        filter->clear();
    }
}




