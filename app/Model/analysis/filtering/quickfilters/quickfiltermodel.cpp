#include "quickfiltermodel.h"
#include <QDebug>
#include <QJsonArray>

#include "transmissionquickfilter.h"
#include "positionquickfilter.h"
#include "qualityquickfilter.h"
#include "typequickfilter.h"
#include "frequencequickfilter.h"
#include "insilicopredquickfilter.h"


QuickFilterModel::QuickFilterModel(QObject *parent) : QObject(parent)
{
}

void QuickFilterModel::init(int refId, int analysisId)
{
    mQuickFilters.clear();
    // Load filter according to the refID, analysisId
    mQuickFilters[TransmissionFilter] = new TransmissionQuickFilter(refId);
    mQuickFilters[QualityFilter] = new QualityQuickFilter(refId);
    mQuickFilters[PositionFilter] = new PositionQuickFilter(refId);
    mQuickFilters[TypeFilter] = new TypeQuickFilter(refId);
    mQuickFilters[FrequenceFilter] = new FrequenceQuickFilter(refId);
    mQuickFilters[InSilicoPredFilter] = new InSilicoPredQuickFilter(refId);

}




QString QuickFilterModel::getFilter()
{
    QStringList filters;
    foreach (QuickFilterBlockInterface* filter, mQuickFilters.values())
    {
        if (filter->isVisible())
        {
            QString f = filter->getFilter();
            if (!f.isEmpty())
            {
                filters << f;
            }
        }
    }

    QString request = QString("[\"AND\",[%1]]").arg(filters.join(","));
    qDebug() << "Quick filter generated : " << request;
    return request;
}

QString QuickFilterModel::checkAnnotationsDB(QList<QObject*> dbs)
{
    mQuickFilters[TransmissionFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[QualityFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[PositionFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[TypeFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[FrequenceFilter]->checkAnnotationsDB(dbs);
    mQuickFilters[InSilicoPredFilter]->checkAnnotationsDB(dbs);
}

void QuickFilterModel::loadFilter(QJsonArray json)
{
    foreach (QuickFilterBlockInterface* filter, mQuickFilters.values())
    {
        filter->loadFilter(json);
    }
}


void QuickFilterModel::clear()
{
    foreach (QuickFilterBlockInterface* filter, mQuickFilters.values())
    {
        filter->clear();
    }
}




