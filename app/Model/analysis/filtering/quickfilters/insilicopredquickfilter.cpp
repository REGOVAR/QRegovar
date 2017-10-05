#include "insilicopredquickfilter.h"
#include <QJsonArray>



InSilicoPredQuickFilter::InSilicoPredQuickFilter(int) : QuickFilterBlockInterface()
{

    // TODO : Retrieve list of available annotations according to the analysisId
    //      : And then retrieve via regexp fields_uid for dbnsfp

    // List of fields uid
//    mFields = QList<QuickFilterField*>();
//    mFields << new QuickFilterField("60b0b4839b6d5695f93667b7204de187", "==", "Benin");   // sift (VEP)
//    mFields << new QuickFilterField("150a41806541fd1c09be22cb1c92b03b", "==", "Benin");   // polyphen (VEP)
//    mFields << new QuickFilterField("89b35362318e2992c3f05f0042889830", ">", 15);         // cadd (dbNSFP)

    mFilter = "[\"%2\", [\"field\", \"%1\"], [\"value\", %3]]";
    mIsVisible = false;
}




bool InSilicoPredQuickFilter::isVisible()
{
    return mIsVisible;
}


QJsonArray InSilicoPredQuickFilter::toJson()
{
    QJsonArray result;
    return result;
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

void InSilicoPredQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
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


bool InSilicoPredQuickFilter::loadJson(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}
