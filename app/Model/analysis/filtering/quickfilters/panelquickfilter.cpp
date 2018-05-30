#include "panelquickfilter.h"
#include "Model/regovar.h"
#include "Model/analysis/filtering/filteringanalysis.h"

PanelQuickFilter::PanelQuickFilter(int analysisId): QuickFilterBlockInterface()
{
    mOperators.clear();
    mOperators.append("∈");
    mOperators.append("∉");


    mPanelsList.clear();

    // Retrieve list of available panel in the analysis settings
    FilteringAnalysis* analysis = regovar->analysesManager()->getOrCreateFilteringAnalysis(analysisId);
    if (analysis->panelsUsed().count() == 0)
    {
        for (QObject* panel: regovar->panelsManager()->panels())
        {
            PanelVersion* version = qobject_cast<Panel*>(panel)->headVersion();
            QuickFilterField* panelFilter = new QuickFilterField(
                        version->id(),
                        version->fullname(),
                        mOperators,  "IN", 0, false, this);
            mPanelsList << panelFilter;
        }
    }
    else
    {
        for (const QString& panelId: analysis->panelsUsed())
        {
            PanelVersion* version = regovar->panelsManager()->getPanelVersion(panelId);
            QuickFilterField* panelFilter = new QuickFilterField(
                        panelId,
                        version->fullname(),
                        mOperators,  "IN", 0, false, this);
            mPanelsList << panelFilter;
        }
    }
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
