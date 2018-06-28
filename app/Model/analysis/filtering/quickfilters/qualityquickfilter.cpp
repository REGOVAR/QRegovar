#include "qualityquickfilter.h"
#include <QJsonArray>



QualityQuickFilter::QualityQuickFilter(int) : QuickFilterBlockInterface()
{
    mOperators.clear();
    mOperators.append("<");
    mOperators.append("≤");
    mOperators.append("=");
    mOperators.append("≥");
    mOperators.append(">");
    mOperators.append("≠");

    mDepth = new QuickFilterField("401b1e5614706ec81bf83e24958f01e5", tr("Depth"), mOperators, "≥", 30);
    mVaf = new QuickFilterField("8b33223f51dd82f69ce32a5032cdff48", tr("VAF"), mOperators, "≥", 0.2);
}


bool QualityQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return true;
}


QJsonArray QualityQuickFilter::toJson()
{
    QJsonArray filters;

    if (mDepth->isActive())
    {
        filters.append(mDepth->toJson());
    }
    if (mVaf->isActive())
    {
        filters.append(mVaf->toJson());
    }

    if (filters.count() > 1)
    {
        QJsonArray result;
        result.append("AND");
        result.append(filters);
        return result;
    }
    else if (filters.count() == 1)
        return filters[0].toArray();
    return filters;
}



void QualityQuickFilter::setFilter(const QString& , bool, QVariant)
{
    // Not used
}



void QualityQuickFilter::clear()
{
    mDepth->clear();
    mVaf->clear();
}

void QualityQuickFilter::checkAnnotationsDB(QList<QObject*>)
{
    //  always available as usign only precomputed field DP
}


bool QualityQuickFilter::loadJson(const QJsonArray &)
{
    // TODO or not TODO ?
    return false;
}

