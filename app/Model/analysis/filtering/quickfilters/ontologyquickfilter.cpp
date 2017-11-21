#include "ontologyquickfilter.h"
#include <QJsonArray>


OntologyQuickFilter::OntologyQuickFilter(int) : QuickFilterBlockInterface()
{

}


void OntologyQuickFilter::init(QString, QString, QStringList, QStringList)
{

}



bool OntologyQuickFilter::isVisible()
{
    return mIsVisible;
}



QJsonArray OntologyQuickFilter::toJson()
{
    QJsonArray filters;
    return filters;
}



void OntologyQuickFilter::setFilter(QString, bool , QVariant)
{
    // Not used...
}



void OntologyQuickFilter::clear()
{

}



void OntologyQuickFilter::checkAnnotationsDB(QList<QObject*>)
{
    // no needs to check annotation's db
}


bool OntologyQuickFilter::loadJson(QJsonArray)
{
    // TODO or not TODO ?
    return false;
}
