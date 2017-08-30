#include "qualityquickfilter.h"



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


QString QualityQuickFilter::getFilter()
{
    if (mDepth->isActive())
    {
        return mFilter.arg(mDepth->fuid(), mOpMapping[mDepth->op()], mDepth->value().toString());
    }
    return "";
}



void QualityQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used
}

void QualityQuickFilter::clear()
{
    mDepth->clear();
}
