#include "insilicopredquickfilter.h"
#include <QJsonArray>



InSilicoPredQuickFilter::InSilicoPredQuickFilter(int) : QuickFilterBlockInterface()
{
    mIsVisible = false;

    // List of fields uid
//    mFields = QList<QuickFilterField*>();
//    mFields << new QuickFilterField("60b0b4839b6d5695f93667b7204de187", "==", "Benin");   // sift (VEP)
//    mFields << new QuickFilterField("150a41806541fd1c09be22cb1c92b03b", "==", "Benin");   // polyphen (VEP)
//    mFields << new QuickFilterField("89b35362318e2992c3f05f0042889830", ">", 15);         // cadd (dbNSFP)

}

void InSilicoPredQuickFilter::init(QString siftUid, QString polyUid, QString caddUid)
{
    mOperators.clear();
    mOperators.append("<");
    mOperators.append("≤");
    mOperators.append("=");
    mOperators.append("≥");
    mOperators.append(">");
    mOperators.append("≠");

    // Sift
    mFields << new QuickFilterField(siftUid, "", mOperators, "==", "tolerated");
    mFields[0]->setIsDisplayed(!siftUid.isEmpty());


    // Polyphen
    mFields << new QuickFilterField(polyUid, "", mOperators, "==", "benign");
    mFields[1]->setIsDisplayed(!polyUid.isEmpty());

    // CADD
    mFields << new QuickFilterField(caddUid, "", mOperators, ">", 15);
    mFields[2]->setIsDisplayed(!caddUid.isEmpty());
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
    QString siftUid = "";
    QString polyUid = "";
    QString caddUid = "";


    mIsVisible = false;
    foreach (QObject* o, dbs)
    {
        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
        if (db->selected())
        {
            if (db->name().toLower() == "vep")
            {
                foreach (Annotation* annot, db->fields())
                {
                    if (annot && annot->name().toLower() == "sift_pred")
                    {
                        siftUid = annot->uid();
                        mIsVisible = true;
                    }
                    if (annot && annot->name().toLower() == "polyphen_pred")
                    {
                        polyUid = annot->uid();
                        mIsVisible = true;
                    }
                    // TODO: retrieve CADD
                }
            }
        }
    }

    init(siftUid, polyUid, caddUid);
    mIsVisible = siftUid.isEmpty() || polyUid.isEmpty() || caddUid.isEmpty();
}


bool InSilicoPredQuickFilter::loadJson(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}
