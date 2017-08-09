#include "qualityquickfilter.h"



QualityQuickFilter::QualityQuickFilter(int analysisId) : QuickFilterBlockInterface()
{
    // TODO : Retrieve list of available annotations according to the analysisId
    //      : And then retrieve via regexp fields_uid for dbnsfp

    mDepth = new QuickFilterField("3ee42adc14f878158deeb74e16131cf5", ">=", 30);
    mFilter = "[\"%2\", [\"field\", \"%1\"], [\"value\", %3]]";
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
        return mFilter.arg(mDepth->fuid(), mDepth->op(), mDepth->value().toString());
    }
    return "";
}



void QualityQuickFilter::setFilter(int id, QVariant value)
{
    // Not used
}

void QualityQuickFilter::clear()
{
    mDepth->clear();
}
