#include "frequencequickfilter.h"




FrequenceQuickFilter::FrequenceQuickFilter(int) : QuickFilterBlockInterface()
{
    mOperators.clear();
    mOperators.append("<");
    mOperators.append("≤");
    mOperators.append("=");
    mOperators.append("≥");
    mOperators.append(">");
    mOperators.append("≠");

    mOpMapping.clear();
    mOpMapping.insert("<", "<");
    mOpMapping.insert("≤", "<=");
    mOpMapping.insert("=", "==");
    mOpMapping.insert("≥", ">=");
    mOpMapping.insert(">", ">");
    mOpMapping.insert("≠", "!=");


    // TODO : Retrieve list of available annotations according to the analysisId
    //      : And then retrieve via regexp fields_uid for dbnsfp

    // List of fields uid
    mFields = QList<QuickFilterField*>();
    mFields << new QuickFilterField("9416b5d08c79ca159bd8f77679ad9045", "1000G All", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("44f47e42744fdad1a9a5947ff1fd7919", "1000G AFR", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("f2edb022d5b41eb63a6062ff14c8fac6", "1000G AMR", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("f3da5bd180f15d44e6e0d4e0d58668fe", "1000G ASN", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("5734cc486eeca19a137ab985d17258dd", "1000G EUR", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("04234b2f9f3c1f503b67bc5a9414bb70", "Exac All", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("a7d7d94c1ea89995d5b35249ef7b63b5", "Exac AFR", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("96740fdc174e6961a181f82fcfc73a30", "Exac AMR", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("c6ad1d16a48fc7848bd290d213bd87f8", "Exac ADJ", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("69d3e28f9d834d12185354c054b93175", "Exac EAS", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("b7a1e0e4f6840e2c69b7d2bff182d2a8", "Exac FIN", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("bdf4ab8bd971af38083be6a554b16179", "Exac NFE", mOperators, "≤", 0.01);
    mFields << new QuickFilterField("0fd18287260793c0e82f81f81c8fc218", "Exac SAS", mOperators, "≤", 0.01);
    foreach (QuickFilterField* field, mFields){ field->setIsActive(false); }

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
            filter << mFilter.arg(field->fuid(), mOpMapping[field->op()], field->value().toString());
        }
    }

    if (filter.count() > 1)
        return QString("[\"AND\", [%1]]").arg(filter.join(","));
    else if (filter.count() == 1)
        return filter[0];
    return "";
}



void FrequenceQuickFilter::setFilter(QString, bool , QVariant)
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
