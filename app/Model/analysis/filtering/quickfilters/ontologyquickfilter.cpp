#include "ontologyquickfilter.h"
#include <QJsonArray>


OntologyQuickFilter::OntologyQuickFilter(int) : QuickFilterBlockInterface()
{

}


void OntologyQuickFilter::init(QString _1000gUid, QString exacUid, QStringList _1000g, QStringList exac)
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



void OntologyQuickFilter::checkAnnotationsDB(QList<QObject*> dbs)
{
    // no needs to check annotation's db
}


bool OntologyQuickFilter::loadJson(QJsonArray)
{
    // TODO or not TODO ?
    return false;
}
