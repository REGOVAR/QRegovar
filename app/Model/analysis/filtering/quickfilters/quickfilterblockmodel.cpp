#include "quickfilterblockinterface.h"

QuickFilterBlockInterface::QuickFilterBlockInterface(QObject *parent) : QObject(parent)
{

}




void QuickFilterBlockInterface::setFilter(PredefinedFilter filter, bool isActive)
{
    mActiveFilters[filter] = isActive;
}



QString QuickFilterBlockInterface::getFilter()
{
    foreach ()
    QString filter = "";

    return QString("['OR', %1]").arg(filter);
}


void QuickFilterBlockInterface::initQuickFilters()
{
    // Transmission filters
    mFilterOptions[TransmissionDominantFilter] = "[['==', ['field', 'b33e172643f14920cee93d25daaa3c7b'], ['value', '2']]]";
    mActiveFilters[TransmissionDominantFilter] = false;
    mQuickFilters[TransmissionRecessiveFilter] = "[['==', ['field', 'b33e172643f14920cee93d25daaa3c7b'], ['value', '1']]]";
    mActiveFilters[TransmissionRecessiveFilter] = false;
    mQuickFilters[TransmissionCompositeFilter] = "[['==', ['field', 'b33e172643f14920cee93d25daaa3c7b'], ['value', '3']]]";
    mActiveFilters[TransmissionCompositeFilter] = false;
}
