#include "frequencequickfilter.h"
#include <QJsonArray>




FrequenceQuickFilter::FrequenceQuickFilter(int) : QuickFilterBlockInterface()
{
    mIsVisible = false;
}



void FrequenceQuickFilter::init(QStringList _1000g, QStringList exac)
{
    mOperators.clear();
    mOperators.append("<");
    mOperators.append("≤");
    mOperators.append("=");
    mOperators.append("≥");
    mOperators.append(">");
    mOperators.append("≠");


    // 1000G
    foreach (QString fuid, _1000g)
    {
        m1000GFields << new QuickFilterField(fuid, mFieldsNames[fuid], mOperators, "<=", "0.01");
    }
    // Exac
    foreach (QString fuid, exac)
    {
        mExacFields << new QuickFilterField(fuid, mFieldsNames[fuid], mOperators, "<=", "0.01");
    }
}



bool FrequenceQuickFilter::isVisible()
{
    return mIsVisible;
}



QJsonArray FrequenceQuickFilter::toJson()
{
    QJsonArray filters;
//    foreach (QuickFilterField* field, mFields)
//    {
//        if (field->isActive())
//        {
//            filters.append(field->toJson());
//        }
//    }

//    if (filters.count() > 1)
//    {
//        QJsonArray result;
//        result.append("AND");
//        result.append(filters);
//        return result;
//    }
//    else if (filters.count() == 1)
//        return filters[0].toArray();
    return filters;
}



void FrequenceQuickFilter::setFilter(QString, bool , QVariant)
{
    // Not used...
}



void FrequenceQuickFilter::clear()
{
    foreach (QObject* o, m1000GFields)
    {
        QuickFilterField* field = qobject_cast<QuickFilterField*>(o);
        field->clear();
    }
    foreach (QObject* o, mExacFields)
    {
        QuickFilterField* field = qobject_cast<QuickFilterField*>(o);
        field->clear();
    }
}



void FrequenceQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
{
    mFieldsNames.clear();
    QStringList _1000gFuids;
    QStringList exacFuids;
    QStringList _1000gLabels;
    // 1000G fields to retrieved (and also to display in this order: gmaf first)
    _1000gLabels << "gmaf" << "aa_maf" << "afr_maf" << "amr_maf" << "asn_maf" << "ea_maf" << "eas_maf" << "eur_maf" << "sas_maf";
    _1000gFuids  << "" << "" << "" << "" << "" << "" << "" << "" << "";

    mIsVisible = false;
    // Retrieve fuid for 1000G and Exac
    foreach (QObject* o, dbs)
    {
        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
        if (db->selected())
        {
            if (db->name().toLower() == "vep")
            {
                foreach (Annotation* annot, db->fields())
                {
                    if (annot)
                    {
                        if (_1000gLabels.contains(annot->name().toLower()))
                        {
                            _1000gFuids[_1000gLabels.indexOf(annot->name().toLower())] = annot->uid();
                            mFieldsNames.insert(annot->uid(), annot->name());
                        }
                        else if (annot->name().toLower().startsWith("exac_"))
                        {
                            exacFuids.append(annot->uid());
                            mFieldsNames.insert(annot->uid(), annot->name());
                        }
                    }
                }
            }
            if (db->name().toLower() == "dbnfsp")
            {
                // TODO set mapping according to dbnfsp 1000G/Exac fields !
            }
        }
    }

    // Clean vep 1000G fields uid
    for (int idx=0; idx < _1000gFuids.count(); idx++)
    {
        if (_1000gFuids[idx].isEmpty())
        {
            _1000gFuids.removeAt(idx);
            idx--;
        }
    }

    // Set visibility of the quick filter and continue init by creating fields
    mIsVisible = _1000gFuids.count() > 0 || exacFuids.count() > 0;
    init(_1000gFuids, exacFuids);
}


bool FrequenceQuickFilter::loadJson(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}




