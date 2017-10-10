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
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "coding_sequence_variant");
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "missense_variant", true);
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "stop_gained", true);

    // Intronic
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "intron_variant");

    // UTR
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "5_prime_UTR_variant");
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "3_prime_UTR_variant", true);

    // Intergenic
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "intergenic_variant");
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "upstream_gene_variant", true);
    mFields << new QuickFilterField("583f8236779ca1e9a67282e5f949d658", tr("CodingSeq"), ops, "==", "downstream_gene_variant", true);

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
    // This filter is always availble in the UI
    return true;
}


QJsonArray PositionQuickFilter::toJson()
{
    QJsonArray result;

    // Exonic
    if (mFields[0]->isActive())
    {
        QJsonArray exonicConditions;
        exonicConditions.append(mFields[0]->toJson());
        exonicConditions.append(mFields[1]->toJson());
        exonicConditions.append(mFields[2]->toJson());
        QJsonArray exonicFilter;
        exonicFilter.append("OR");
        exonicFilter.append(exonicConditions);
        result.append(exonicFilter);
    }
    // Intronic
    if (mFields[3]->isActive())
    {
        result.append(mFields[3]->toJson());
    }
    // UTR
    if (mFields[4]->isActive())
    {
        QJsonArray utrConditions;
        utrConditions.append(mFields[4]->toJson());
        utrConditions.append(mFields[5]->toJson());
        QJsonArray utrFilter;
        utrFilter.append("OR");
        utrFilter.append(utrConditions);
        result.append(utrFilter);
    }
    // Intergenic
    if (mFields[6]->isActive())
    {
        QJsonArray interConditions;
        interConditions.append(mFields[6]->toJson());
        interConditions.append(mFields[7]->toJson());
        interConditions.append(mFields[8]->toJson());
        QJsonArray interFilter;
        interFilter.append("OR");
        interFilter.append(interConditions);
        result.append(interFilter);
    }

    if (result.count() == 1)
        return result[0].toArray();
    return result;
}



void PositionQuickFilter::setFilter(QString, bool, QVariant)
{
    // Not used...
}

void PositionQuickFilter::clear()
{
    mFields[0]->clear();
    mFields[3]->clear();
    mFields[4]->clear();
    mFields[6]->clear();
}


//! Activate this filter only if VEP database with consequence field is available
void PositionQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
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



bool PositionQuickFilter::loadJson(QJsonArray filter)
{
    // TODO or not TODO ?
    return false;
}
