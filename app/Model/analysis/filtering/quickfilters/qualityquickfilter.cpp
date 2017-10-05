#include "qualityquickfilter.h"
#include <QJsonArray>



QualityQuickFilter::QualityQuickFilter(int) : QuickFilterBlockInterface()
{
    // TODO : Retrieve list of available annotations according to the analysisId
    //      : And then retrieve via regexp fields_uid for dbnsfp

    mOperators.clear();
    mOperators.append("<");
    mOperators.append("≤");
    mOperators.append("=");
    mOperators.append("≥");
    mOperators.append(">");
    mOperators.append("≠");

    mDepth = new QuickFilterField("401b1e5614706ec81bf83e24958f01e5", tr("Depth"), mOperators, "≥", 30);
    mDepth->setIsActive(false);
    mFilter = "[\"%2\", [\"field\", \"%1\"], [\"value\", %3]]";

    mOpMapping.clear();
    mOpMapping.insert("<", "<");
    mOpMapping.insert("≤", "<=");
    mOpMapping.insert("=", "==");
    mOpMapping.insert("≥", ">=");
    mOpMapping.insert(">", ">");
    mOpMapping.insert("≠", "!=");
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
}


bool QualityQuickFilter::loadJson(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}

