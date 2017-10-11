#include "typequickfilter.h"
#include <QJsonArray>

TypeQuickFilter::TypeQuickFilter(int) : QuickFilterBlockInterface()
{
    mIsVisible = false;
}


void TypeQuickFilter::init(QString fuid)
{
    QStringList ops;
    ops << "=";
    // Missence
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", ops, "==", "missense_variant");

    // Nonsence
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", ops, "==", "stop_gained");

    // Splicing
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", ops, "==", "splice_acceptor_variant");
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", ops, "==", "splice_donor_variant", true);

    // Indel
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", ops, "==", "frameshift_variant");
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", ops, "==", "inframe_insertion", true);
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", ops, "==", "inframe_deletion", true);

    // Synonymous
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", "", ops, "==", "synonymous_variant");
}


bool TypeQuickFilter::isVisible()
{
    return mIsVisible;
}


QJsonArray TypeQuickFilter::toJson()
{
    QJsonArray conditions;
    // Missence
    if (mFields[0]->isActive())
    {
        conditions.append(mFields[0]->toJson());
    }
    // Nonsence
    if (mFields[1]->isActive())
    {
        conditions.append(mFields[1]->toJson());
    }
    // Splicing
    if (mFields[2]->isActive())
    {
        conditions.append(mFields[2]->toJson());
        conditions.append(mFields[3]->toJson());
    }
    // Indel
    if (mFields[4]->isActive())
    {
        conditions.append(mFields[4]->toJson());
        conditions.append(mFields[5]->toJson());
        conditions.append(mFields[6]->toJson());
    }
    // Synonymous
    if (mFields[7]->isActive())
    {
        conditions.append(mFields[7]->toJson());
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



void TypeQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used...
}

void TypeQuickFilter::clear()
{
    mFields[0]->clear();
    mFields[1]->clear();
    mFields[2]->clear();
    mFields[4]->clear();
    mFields[7]->clear();
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
                foreach (Annotation* annot, db->fields())
                {
                    if (annot && annot->name().toLower() == "consequence")
                    {
                        init(annot->uid());
                        mIsVisible = true;
                        return;
                    }
                }
            }
        }
    }
}


bool TypeQuickFilter::loadJson(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}
