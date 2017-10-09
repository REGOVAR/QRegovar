#include "positionquickfilter.h"
#include <QJsonArray>

PositionQuickFilter::PositionQuickFilter(int) : QuickFilterBlockInterface()
{
// vep consequence
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


    //	effecteffect_impact
//    mFields = QList<QuickFilterField*>();
//    mFields << new QuickFilterField("5803633f01600a2e047aad3ee2faa133", "==", "exonic");
    // coding_sequence_variant
    // missense_variant
    // stop_gained

//    "5803633f01600a2e047aad3ee2faa133" "intronic"
    // intron_variant
//    "5803633f01600a2e047aad3ee2faa133" "UTR"
    // 5_prime_UTR_variant
    // 3_prime_UTR_variant
//   "5803633f01600a2e047aad3ee2faa133" "intergenic"
    // intergenic_variant
    // upstream_gene_variant    Upstream gene
    // downstream_gene_variant  Downstream gene

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
