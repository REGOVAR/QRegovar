#include "transmissionquickfilter.h"
#include <QJsonArray>

// This quick filter is using several of precomputed regovar's annotations
// These annotations are done and use same fuid for all analaysis/ref
// fuid mapping
// is_dom           148e67ffc504d1d0baf8ec988a2b7c4e
// is_rec_hom       b0fab8b285474229afbbc13fac198dfe
// is_rec_htzcomp   8cb83d0127aa912f2d290139d298e082
// is_denovo        92a9da3488b1127623c4e3ac7b6f67e2
// is_inherited     7ea7055963560e3ba97bd5a0081fa66c
// is_aut           9b3a9330bc8b5b3c1ebc271876535d8e
// is_xlk           76117d8b774f5e902ba0580bc302afb0
// is_mit           0bfb15c0aad2926202f1ca0ee4e44c59

TransmissionQuickFilter::TransmissionQuickFilter(int) : QuickFilterBlockInterface()
{
    // Dominant
    mFilters["dom"] = "[\"==\", [\"field\", \"148e67ffc504d1d0baf8ec988a2b7c4e\"], [\"value\", true]]";
    mActiveFilters["dom"] = false;
    // Recessif
    mFilters["rec_hom"] = "[\"==\", [\"field\", \"b0fab8b285474229afbbc13fac198dfe\"], [\"value\", true]]";
    mActiveFilters["rec_hom"] = false;
    mFilters["rec_htzcomp"] = "[\"==\", [\"field\", \"8cb83d0127aa912f2d290139d298e082\"], [\"value\", true]]";
    mActiveFilters["rec_htzcomp"] = false;
    // De novo
    mFilters["denovo"] = "[\"==\", [\"field\", \"92a9da3488b1127623c4e3ac7b6f67e2\"], [\"value\", true]]";
    mActiveFilters["denovo"] = false;
    // Inherited
    mFilters["inherited"] = "[\"==\", [\"field\", \"7ea7055963560e3ba97bd5a0081fa66c\"], [\"value\", true]]";
    mActiveFilters["inherited"] = false;
    // Autosomal
    mFilters["aut"] = "[\"==\", [\"field\", \"9b3a9330bc8b5b3c1ebc271876535d8e\"], [\"value\", true]]";
    mActiveFilters["aut"] = false;
    // X-linked
    mFilters["xlk"] = "[\"==\", [\"field\", \"76117d8b774f5e902ba0580bc302afb0\"], [\"value\", true]]";
    mActiveFilters["xlk"] = false;
    // Mito
    mFilters["mit"] = "[\"==\", [\"field\", \"0bfb15c0aad2926202f1ca0ee4e44c59\"], [\"value\", true]]";
    mActiveFilters["mit"] = false;
}


bool TransmissionQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return true;
}


QString TransmissionQuickFilter::getFilter()
{
    QStringList filter;
    QStringList recFilter;
    foreach(QString fid, mActiveFilters.keys())
    {
        if (mActiveFilters[fid])
        {
            // TODO manage Rec filter (hom OR htzcomp)

            filter << mFilters[fid];
        }
    }

    if (filter.count() > 1)
        return QString("[\"AND\", [%1]]").arg(filter.join(","));
    else if (filter.count() == 1)
        return filter[0];
    return "";
}



void TransmissionQuickFilter::setFilter(QString filterId, bool filterActive, QVariant)
{
    mActiveFilters[filterId] = filterActive;
}



void TransmissionQuickFilter::clear()
{
    foreach(QString fid, mActiveFilters.keys())
    {
        mActiveFilters[fid] = false;
    }
}

void TransmissionQuickFilter::checkAnnotationsDB(QList<QObject*>)
{
}


bool TransmissionQuickFilter::loadFilter(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}
