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
}


bool QualityQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return true;
}


QJsonArray QualityQuickFilter::toJson()
{
    if (mDepth->isActive())
    {
        return mDepth->toJson();
    }
    return QJsonArray();
}



void QualityQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used
}



void QualityQuickFilter::clear()
{
    mDepth->clear();
}

void QualityQuickFilter::checkAnnotationsDB(QList<QObject*>)
{
    //  always available as usign only precomputed field DP
}


bool QualityQuickFilter::loadJson(QJsonArray)
{
    // TODO or not TODO ?
    return false;
}

