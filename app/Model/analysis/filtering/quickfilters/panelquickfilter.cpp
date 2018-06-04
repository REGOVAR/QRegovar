#include "panelquickfilter.h"
#include "Model/regovar.h"
#include "Model/analysis/filtering/filteringanalysis.h"

PanelQuickFilter::PanelQuickFilter(int): QuickFilterBlockInterface()
{
    mOperators.clear();
    mOperators.append("∈");
    mOperators.append("∉");


    mPanelsList.clear();

    // Retrieve list of head panels
    for (int idx=0; idx <  regovar->panelsManager()->panels()->proxy()->rowCount(); idx++)
    {
        QModelIndex i1 = regovar->panelsManager()->panels()->proxy()->getModelIndex(idx);
        // TODO: fix get panel sorted by name
        // QModelIndex i2 = regovar->panelsManager()->panels()->proxy()->mapToSource(i1);
        PanelVersion* version =regovar->panelsManager()->panels()->getAt(i1.row());
        QuickFilterField* panelFilter = new QuickFilterField(
                    version->id(),
                    version->fullname(),
                    mOperators,  "IN", 0, false, this);
        mPanelsList << panelFilter;
    }

    // TODO: Add specific panels that have been added by users
//    FilteringAnalysis* analysis = regovar->analysesManager()->getOrCreateFilteringAnalysis(analysisId);
//    if (analysis->panelsUsed().count() > 0)
//    {
//        for (const QString& panelId: analysis->panelsUsed())
//        {
//            PanelVersion* version = regovar->panelsManager()->getPanelVersion(panelId);
//            QuickFilterField* panelFilter = new QuickFilterField(
//                        panelId,
//                        version->fullname(),
//                        mOperators,  "IN", 0, false, this);
//            mPanelsList << panelFilter;
//        }
//    }
}



bool PanelQuickFilter::isVisible()
{
    return true; // mIsVisible;
}


QJsonArray PanelQuickFilter::toJson()
{
    QJsonArray filters;
    // Sift
    for (QObject* o: mPanelsList)
    {
        QuickFilterField* field = qobject_cast<QuickFilterField*>(o);
        if (field != nullptr && field->isActive())
        {
            QJsonArray opLeft;
            opLeft.append("panel");
            opLeft.append(field->fuid());

            QJsonArray result;
            result.append(field->op());
            result.append(opLeft);

            filters.append(result);
        }
    }

    if (filters.count() > 1)
    {
        QJsonArray result;
        result.append("OR");
        result.append(filters);
        return result;
    }
    else if (filters.count() == 1)
        return filters[0].toArray();
    return filters;
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

void PanelQuickFilter::checkAnnotationsDB(QList<QObject*>)
{
    // Nothing to do
}


bool PanelQuickFilter::loadJson(QJsonArray)
{
    // TODO or not TODO ?
    return false;
}
