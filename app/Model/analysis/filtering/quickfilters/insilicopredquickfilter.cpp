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

    // Missence
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", mOperators, "==", "missense_variant");

    // Nonsence
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", mOperators, "==", "stop_gained");

    // Splicing
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", mOperators, "==", "splice_acceptor_variant");
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", mOperators, "==", "splice_donor_variant", true);

    // Indel
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", mOperators, "==", "frameshift_variant");
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", mOperators, "==", "inframe_insertion", true);
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", mOperators, "==", "inframe_deletion", true);

    // Synonymous
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", mOperators, "==", "synonymous_variant");
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
}


bool InSilicoPredQuickFilter::loadJson(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}
