#include "transmissionquickfilter.h"

TransmissionQuickFilter::TransmissionQuickFilter(int analysisId) : QuickFilterBlockInterface()
{
    // Dominant - ref/alt
    mFilters[0] = "[\"==\", [\"field\", \"b33e172643f14920cee93d25daaa3c7b\"], [\"value\", \"2\"]]";
    mActiveFilters[0] = false;
    // Recessif - alt/alt
    mFilters[1] = "[\"==\", [\"field\", \"b33e172643f14920cee93d25daaa3c7b\"], [\"value\", \"1\"]]";
    mActiveFilters[1] = false;
    // Composite - alt1/alt2
    mFilters[2] = "[\"==\", [\"field\", \"212a9e5be0a47eea6ed028af9992e1bb\"], [\"value\", true]]";
    mActiveFilters[2] = false;
}


bool TransmissionQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return true;
}


QString TransmissionQuickFilter::getFilter()
{
    QStringList filter;
    for (int idx=0; idx < mActiveFilters.count(); idx++)
    {
        if (mActiveFilters[idx])
        {
            filter << mFilters[idx];
        }
    }

    if (filter.count() > 1)
        return QString("[\"OR\", [%1]]").arg(filter.join(","));
    else if (filter.count() == 1)
        return filter[0];
    return "";
}



void TransmissionQuickFilter::setFilter(int id, QVariant value)
{
    mActiveFilters[id] = value.toBool();
}

void TransmissionQuickFilter::clear()
{
    mActiveFilters[0] = false;
    mActiveFilters[1] = false;
    mActiveFilters[2] = false;
}
