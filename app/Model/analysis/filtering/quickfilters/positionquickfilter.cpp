#include "positionquickfilter.h"

PositionQuickFilter::PositionQuickFilter(int analysisId) : QuickFilterBlockInterface()
{
    //	effecteffect_impact
    mFields = QList<QuickFilterField*>();
    mFields << new QuickFilterField("4e39ceb7e0ec73f3d734de59e241fb6d", "==", "exonic");
    mFields << new QuickFilterField("4e39ceb7e0ec73f3d734de59e241fb6d", "==", "intronic");
    mFields << new QuickFilterField("4e39ceb7e0ec73f3d734de59e241fb6d", "==", "utr");
    mFields << new QuickFilterField("4e39ceb7e0ec73f3d734de59e241fb6d", "==", "intergene");

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



void PositionQuickFilter::setFilter(int id, QVariant value)
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
