#include "positionquickfilter.h"
#include <QJsonArray>

PositionQuickFilter::PositionQuickFilter(int) : QuickFilterBlockInterface()
{
    mIsVisible = false;
}


void PositionQuickFilter::init(QString fuid)
{
    QStringList ops;
    ops << "=";
    // Exonic
    mFields << new QuickFilterField("aeba63be9600e56a88e401e8e6a5103d", tr("Exonic"), ops, "=", QVariant(true));
    // Intronic
    mFields << new QuickFilterField(fuid, "", ops, "=", "intron_variant");
    // UTR
    mFields << new QuickFilterField(fuid, "", ops, "=", "5_prime_UTR_variant");
    mFields << new QuickFilterField(fuid, "", ops, "=", "3_prime_UTR_variant", true);

    // Intergenic
    mFields << new QuickFilterField(fuid, "", ops, "=", "intergenic_variant");
    mFields << new QuickFilterField(fuid, "", ops, "=", "upstream_gene_variant", true);
    mFields << new QuickFilterField(fuid, "", ops, "=", "downstream_gene_variant", true);

    // Splice
    mFields << new QuickFilterField(fuid, "", ops, "=", "splice_acceptor_variant");
    mFields << new QuickFilterField(fuid, "", ops, "=", "splice_donor_variant", true);
    mFields << new QuickFilterField(fuid, "", ops, "=", "splice_region_variant", true);

 // vep consequence not used : (check also with TypeQuickFilter)
    // transcript_ablation
    // start_lost
    // stop_lost
    // transcript_amplification
    // protein_altering_variantx
    // incomplete_terminal_codon_variant
    // stop_retained_variant
    // mature_miRNA_variant
    // non_coding_transcript_exon_variant
    // non_coding_transcript_variant
    // NMD_transcript_variant
    // TFBS_ablation
    // TFBS_amplification
    // TF_binding_site_variant
    // regulatory_region_ablation
    // regulatory_region_amplification
    // feature_elongation
    // regulatory_region_variant
    // feature_truncation
}


bool PositionQuickFilter::isVisible()
{
    return mIsVisible;
}


QJsonArray PositionQuickFilter::toJson()
{
    QJsonArray conditions;
    // Exonic
    if (mFields[0]->isActive())
    {
        conditions.append(mFields[0]->toJson());
    }
    // Intronic
    if (mFields[1]->isActive())
    {
        conditions.append(mFields[1]->toJson());
    }
    // UTR
    if (mFields[2]->isActive())
    {
        conditions.append(mFields[2]->toJson());
        conditions.append(mFields[3]->toJson());
    }
    // Intergenic
    if (mFields[4]->isActive())
    {
        conditions.append(mFields[4]->toJson());
        conditions.append(mFields[5]->toJson());
        conditions.append(mFields[6]->toJson());
    }
    // Splice
    if (mFields[7]->isActive())
    {
        conditions.append(mFields[7]->toJson());
        conditions.append(mFields[8]->toJson());
        conditions.append(mFields[9]->toJson());
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



void PositionQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used...
}

void PositionQuickFilter::clear()
{
    mFields[0]->clear();
    mFields[1]->clear();
    mFields[2]->clear();
    mFields[4]->clear();
    mFields[7]->clear();
}


//! Activate this filter only if VEP database with consequence field is available
void PositionQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
{
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
                    if (annot && annot->name().toLower() == "consequence")
                    {
                        init(annot->uid());
                        mIsVisible = true;
                        return;
                    }
                }
            }
            if (db->name().toLower() == "snpeff")
            {
                for (Annotation* annot: db->fields())
                {
                    if (annot && annot->name().toLower() == "annotation")
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



bool PositionQuickFilter::loadJson(QJsonArray)
{
    // TODO or not TODO ?
    return false;
}
