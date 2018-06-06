#include "phenotypequickfilter.h"
#include <QJsonArray>


PhenotypeQuickFilter::PhenotypeQuickFilter(int) : QuickFilterBlockInterface()
{
    mHpoList = new HpoDataListModel(this);
}


void PhenotypeQuickFilter::init(QString, QString, QStringList, QStringList)
{

}



bool PhenotypeQuickFilter::isVisible()
{
    return mIsVisible;
}



QJsonArray PhenotypeQuickFilter::toJson()
{
    QJsonArray filters;
    return filters;
}



void PhenotypeQuickFilter::setFilter(QString, bool , QVariant)
{
    // Not used...
}



void PhenotypeQuickFilter::clear()
{

}



void PhenotypeQuickFilter::checkAnnotationsDB(QList<QObject*>)
{
    // no needs to check annotation's db
}


bool PhenotypeQuickFilter::loadJson(QJsonArray)
{
    // TODO or not TODO ?
    return false;
}
