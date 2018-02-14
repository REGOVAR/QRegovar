#include "insilicopredquickfilter.h"
#include <QJsonArray>



InSilicoPredQuickFilter::InSilicoPredQuickFilter(int) : QuickFilterBlockInterface()
{
    mIsVisible = false;
}



void InSilicoPredQuickFilter::init(QString siftUid, QString polyUid, QString caddUid, QString impactUid)
{
    mOperators.clear();
    mOperators.append("<");
    mOperators.append("≤");
    mOperators.append("=");
    mOperators.append("≥");
    mOperators.append(">");
    mOperators.append("≠");

    // Sift
    mFields << new QuickFilterField(siftUid, "", mOperators, "=", "tolerated");
    mFields[0]->setIsDisplayed(!siftUid.isEmpty());
    mFields[0]->setIsActive(false);


    // Polyphen
    mFields << new QuickFilterField(polyUid, "", mOperators, "=", "benign");
    mFields[1]->setIsDisplayed(!polyUid.isEmpty());
    mFields[1]->setIsActive(false);

    // CADD
    mFields << new QuickFilterField(caddUid, "", mOperators, "≥", 15);
    mFields[2]->setIsDisplayed(!caddUid.isEmpty());
    mFields[2]->setIsActive(false);

    // SnpEff Impact
    mFields << new QuickFilterField(impactUid, "", mOperators, "=", "modifier");
    mFields[3]->setIsDisplayed(!impactUid.isEmpty());
    mFields[3]->setIsActive(false);

}




bool InSilicoPredQuickFilter::isVisible()
{
    bool result = false;
    for (QuickFilterField* qf: mFields)
    {
        result = result || qf->isDisplayed();
    }
    return result;
}


QJsonArray InSilicoPredQuickFilter::toJson()
{
    QJsonArray conditions;
    // Sift
    if (mFields[0]->isActive())
    {
        QuickFilterField* field = mFields[0];
        QString old = field->value().toString();
        conditions.append(field->toJson());
        field->setValue(old + "_low_confidence");
        conditions.append(field->toJson());
        field->setValue(old);
    }
    // Polyphen
    if (mFields[1]->isActive())
    {
        conditions.append(mFields[1]->toJson());
    }
    // CADD
    if (mFields[2]->isActive())
    {
        conditions.append(mFields[2]->toJson());
    }
    // Impact
    if (mFields[3]->isActive())
    {
        conditions.append(mFields[3]->toJson());
    }

    if (conditions.count() == 0)
    {
        return conditions;
    }
    if (conditions.count() == 1)
    {
        return conditions[0].toArray();
    }

    QJsonArray result;
    result.append("OR");
    result.append(conditions);
    return result;
}



void InSilicoPredQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used...
}

void InSilicoPredQuickFilter::clear()
{
    for (QuickFilterField* field: mFields)
    {
        field->clear();
    }
}

void InSilicoPredQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
{
    QString siftUid = "";
    QString polyUid = "";
    QString caddUid = "";
    QString impactUid = "";


    mIsVisible = false;
    for (QObject* o: dbs)
    {
        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
        if (db->selected())
        {
            if (db->name().toLower() == "vep")
            {
                for (Annotation* annot: db->fields())
                {
                    if (annot && annot->name().toLower() == "sift_pred")
                    {
                        siftUid = annot->uid();
                        mIsVisible = true;
                    }
                    else if (annot && annot->name().toLower() == "polyphen_pred")
                    {
                        polyUid = annot->uid();
                        mIsVisible = true;
                    }
                    // TODO: retrieve CADD
                }
            }
            if (db->name().toLower() == "snpeff")
            {
                for (Annotation* annot: db->fields())
                {
                    if (annot && annot->name().toLower() == "annotation_impact")
                    {
                        impactUid = annot->uid();
                        mIsVisible = true;
                    }
                }
            }
        }
    }

    init(siftUid, polyUid, caddUid, impactUid);
}


bool InSilicoPredQuickFilter::loadJson(QJsonArray)
{
    // TODO or not TODO ?
    return false;
}
