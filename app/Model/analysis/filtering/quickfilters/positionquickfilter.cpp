#include "positionquickfilter.h"
#include <QJsonArray>

PositionQuickFilter::PositionQuickFilter(int) : QuickFilterBlockInterface()
{
    //	effecteffect_impact
//    mFields = QList<QuickFilterField*>();
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "exonic");
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "intronic");
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "utr");
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "intergene");

    mFilter = "[\"%2\", [\"field\", \"%1\"], [\"value\", %3]]";
    mIsVisible = false;
}


bool PositionQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return true;
}


QJsonArray PositionQuickFilter::toJson()
{
    QJsonArray result;
    return result;
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



void PositionQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
{
    mIsVisible = false;
    foreach (QObject* o, dbs)
    {
        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
        if (db->selected())
        {
            if (db->name().toLower() == "dbnfsp")
            {
                // TODO set mapping according to keys !
                mIsVisible = true;
                return;
            }
        }
    }
}



bool PositionQuickFilter::loadJson(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}
