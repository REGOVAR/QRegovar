#include "panelquickfilter.h"

PanelQuickFilter::PanelQuickFilter(int): QuickFilterBlockInterface()
{
    mIsVisible = false;
}



bool PanelQuickFilter::isVisible()
{
    return mIsVisible;
}


QJsonArray PanelQuickFilter::toJson()
{/*
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
    result.append(conditions);*/
    return QJsonArray();
}



void PanelQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used...
}

void PanelQuickFilter::clear()
{
//    for (QuickFilterField* field: mFields)
//    {
//        field->clear();
//    }
}

void PanelQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
{
//    QString siftUid = "";
//    QString polyUid = "";
//    QString caddUid = "";


//    mIsVisible = false;
//    for (QObject* o: dbs)
//    {
//        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
//        if (db->selected())
//        {
//            if (db->name().toLower() == "vep")
//            {
//                for (Annotation* annot: db->fields())
//                {
//                    if (annot && annot->name().toLower() == "sift_pred")
//                    {
//                        siftUid = annot->uid();
//                        mIsVisible = true;
//                    }
//                    else if (annot && annot->name().toLower() == "polyphen_pred")
//                    {
//                        polyUid = annot->uid();
//                        mIsVisible = true;
//                    }
//                    // TODO: retrieve CADD
//                }
//            }
//        }
//    }

//    init(siftUid, polyUid, caddUid);
//    mIsVisible = siftUid.isEmpty() || polyUid.isEmpty() || caddUid.isEmpty();
}


bool PanelQuickFilter::loadJson(QJsonArray)
{
    // TODO or not TODO ?
    return false;
}
