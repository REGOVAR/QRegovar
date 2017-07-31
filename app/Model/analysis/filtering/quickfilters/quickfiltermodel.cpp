#include "quickfiltermodel.h"

#include "transmissionquickfilter.h"

QuickFilterModel::QuickFilterModel(QObject *parent) : QObject(parent)
{
}

void QuickFilterModel::init(int refId, int analysisId)
{
    mQuickFilters.clear();
    // Load filter according to the refID, analysisId
    mQuickFilters[TransmissionFilter] = new TransmissionQuickFilter(refId);
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




