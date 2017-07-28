#ifndef TRANSMISSIONQUICKFILTER_H
#define TRANSMISSIONQUICKFILTER_H

#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class TransmissionQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT
public:
    explicit TransmissionQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QString getFilter();
    Q_INVOKABLE void setFilter(int id, QVariant value);


private:
    QHash<int, QString> mFilters;
    QHash<int, bool> mActiveFilters;
};

#endif // TRANSMISSIONQUICKFILTER_H
