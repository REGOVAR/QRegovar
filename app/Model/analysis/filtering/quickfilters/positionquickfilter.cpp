#include "positionquickfilter.h"

PositionQuickFilter::PositionQuickFilter(int) : QuickFilterBlockInterface()
{
    //	effecteffect_impact
//    mFields = QList<QuickFilterField*>();
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "exonic");
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "intronic");
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "utr");
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "intergene");

    mFilter = "[\"%2\", [\"field\", \"%1\"], [\"value\", %3]]";
}


bool PositionQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return true;
}


QString PositionQuickFilter::getFilter()
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



void PositionQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used...
}

void PositionQuickFilter::clear()
{
    foreach (QuickFilterField* field, mFields)
    {
        field->clear();
    }
}
