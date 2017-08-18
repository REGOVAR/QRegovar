#include "insilicopredquickfilter.h"



InSilicoPredQuickFilter::InSilicoPredQuickFilter(int) : QuickFilterBlockInterface()
{

    // TODO : Retrieve list of available annotations according to the analysisId
    //      : And then retrieve via regexp fields_uid for dbnsfp

    // List of fields uid
    mFields = QList<QuickFilterField*>();
    mFields << new QuickFilterField("60b0b4839b6d5695f93667b7204de187", "==", "Benin");   // sift (VEP)
    mFields << new QuickFilterField("150a41806541fd1c09be22cb1c92b03b", "==", "Benin");   // polyphen (VEP)
    mFields << new QuickFilterField("89b35362318e2992c3f05f0042889830", ">", 15);         // cadd (dbNSFP)

    mFilter = "[\"%2\", [\"field\", \"%1\"], [\"value\", %3]]";
}




bool InSilicoPredQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return true;
}


QString InSilicoPredQuickFilter::getFilter()
{
    QStringList filter;
    foreach (QuickFilterField* field, mFields)
    {
        if (field->isActive())
        {
            filter << mFilter.arg(field->fuid(), field->op(), field->value().toString());
        }
    }

    if (filter.count() > 1)
        return QString("[\"OR\", [%1]]").arg(filter.join(","));
    else if (filter.count() == 1)
        return filter[0];
    return "";
}



void InSilicoPredQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used...
}

void InSilicoPredQuickFilter::clear()
{
    foreach (QuickFilterField* field, mFields)
    {
        field->clear();
    }
}
