#include "frequencequickfilter.h"




FrequenceQuickFilter::FrequenceQuickFilter(int analysisId) : QuickFilterBlockInterface()
{
    // For all above list, the order of idx is the same
    //  0	1000gp1_af
    //  1   1000gp1_afr_af
    //  2	1000gp1_amr_af
    //  3	1000gp1_asn_af
    //  4	1000gp1_eur_af
    //  5	exac_af
    //  6	exac_afr_af
    //  7	exac_amr_af
    //  8	exac_adj_af
    //  9	exac_eas_af
    // 10	exac_fin_af
    // 11	exac_nfe_af
    // 12	exac_sas_af


    // TODO : Retrieve list of available annotations according to the analysisId
    //      : And then retrieve via regexp fields_uid for dbnsfp

    // List of fields uid
    mFields = QList<QuickFilterField*>();
    mFields << new QuickFilterField("9416b5d08c79ca159bd8f77679ad9045", "<=", 0.01); //	1000gp1_af
    mFields << new QuickFilterField("44f47e42744fdad1a9a5947ff1fd7919", "<=", 0.01); //	1000gp1_afr_af
    mFields << new QuickFilterField("f2edb022d5b41eb63a6062ff14c8fac6", "<=", 0.01); //	1000gp1_amr_af
    mFields << new QuickFilterField("f3da5bd180f15d44e6e0d4e0d58668fe", "<=", 0.01); //	1000gp1_asn_af
    mFields << new QuickFilterField("5734cc486eeca19a137ab985d17258dd", "<=", 0.01); //	1000gp1_eur_af
    mFields << new QuickFilterField("04234b2f9f3c1f503b67bc5a9414bb70", "<=", 0.01); //	exac_af
    mFields << new QuickFilterField("a7d7d94c1ea89995d5b35249ef7b63b5", "<=", 0.01); //	exac_afr_af
    mFields << new QuickFilterField("96740fdc174e6961a181f82fcfc73a30", "<=", 0.01); //	exac_amr_af
    mFields << new QuickFilterField("c6ad1d16a48fc7848bd290d213bd87f8", "<=", 0.01); //	exac_adj_af
    mFields << new QuickFilterField("69d3e28f9d834d12185354c054b93175", "<=", 0.01); //	exac_eas_af
    mFields << new QuickFilterField("b7a1e0e4f6840e2c69b7d2bff182d2a8", "<=", 0.01); //	exac_fin_af
    mFields << new QuickFilterField("bdf4ab8bd971af38083be6a554b16179", "<=", 0.01); //	exac_nfe_af
    mFields << new QuickFilterField("0fd18287260793c0e82f81f81c8fc218", "<=", 0.01); //	exac_sas_af


    mFilter = "[\"%2\", [\"field\", \"%1\"], [\"value\", %3]]";
}


bool FrequenceQuickFilter::isVisible()
{
    // This filter is always availble in the UI
    return true;
}


QString FrequenceQuickFilter::getFilter()
{
    QStringList filter;
    foreach (QuickFilterField* field, mFields)
    {
        if (field->isActive())
        {
            filter << mFilter.arg(field->fuid(), field->op(), field->value().toString());
        }
    }

    if (filter.count() > 1)
        return QString("[\"AND\", [%1]]").arg(filter.join(","));
    else if (filter.count() == 1)
        return filter[0];
    return "";
}



void FrequenceQuickFilter::setFilter(int id, QVariant value)
{
    // Not used...
}

void FrequenceQuickFilter::clear()
{
    foreach (QuickFilterField* field, mFields)
    {
        field->clear();
    }
}
