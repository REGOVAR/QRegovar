#include "typequickfilter.h"
#include <QJsonArray>

TypeQuickFilter::TypeQuickFilter(int) : QuickFilterBlockInterface()
{
    //	effecteffect_impact
//    mFields = QList<QuickFilterField*>();
//    mFields << new QuickFilterField("4e39ceb7e0ec73f3d734de59e241fb6d", "==", "missense");
//    mFields << new QuickFilterField("4e39ceb7e0ec73f3d734de59e241fb6d", "==", "nonsense");
//    mFields << new QuickFilterField("4e39ceb7e0ec73f3d734de59e241fb6d", "==", "splicing");

    mFilter = "[\"%2\", [\"field\", \"%1\"], [\"value\", %3]]";
    mIsVisible = false;
}


bool TypeQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return mIsVisible;
}


QString TypeQuickFilter::getFilter()
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



void TypeQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used...
}

void TypeQuickFilter::clear()
{
    foreach (QuickFilterField* field, mFields)
    {
        field->clear();
    }
}

void TypeQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
{
    mIsVisible = false;
    foreach (QObject* o, dbs)
    {
        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
        if (db->selected())
        {
            if (db->name().toLower() == "vep")
            {
                // TODO set mapping according to keys !
                mIsVisible = true;
                return;
            }
        }
    }
}


bool TypeQuickFilter::loadFilter(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}
