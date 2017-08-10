#include "quickfiltermodel.h"

#include "transmissionquickfilter.h"
#include "positionquickfilter.h"
#include "qualityquickfilter.h"
#include "typequickfilter.h"
#include "frequencequickfilter.h"
#include "insilicopredquickfilter.h"

QuickFilterModel::QuickFilterModel(QObject *parent) : QObject(parent)
{
}

void QuickFilterModel::init(int refId, int analysisId)
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

void QuickFilterModel::setFilter(PredefinedFilter filter, int fieldId, QVariant value)
{
    if (mQuickFilters.contains(filter) && mQuickFilters[filter]->isVisible())
    {
        mQuickFilters[filter]->setFilter(fieldId, value);
        emit filterUpdated();
    }
}



QString QuickFilterModel::getFilter()
{
    QStringList filters;
    foreach (QuickFilterBlockInterface* filter, mQuickFilters.values())
    {
        if (filter->isVisible())
        {
            QString f = filter->getFilter();
            if (!f.isEmpty())
            {
                filters << f;
            }
        }
    }

    return QString("[\"AND\",[%1]]").arg(filters.join(","));
}

void QuickFilterModel::clear()
{
    foreach (QuickFilterBlockInterface* filter, mQuickFilters.values())
    {
        filter->clear();
    }
}




