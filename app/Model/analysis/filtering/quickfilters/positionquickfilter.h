#ifndef POSITIONQUICKFILTER_H
#define POSITIONQUICKFILTER_H



#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class PositionQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(QuickFilterField* exonic READ exonic)
    Q_PROPERTY(QuickFilterField* intronic READ intronic)
    Q_PROPERTY(QuickFilterField* utr READ utr)
    Q_PROPERTY(QuickFilterField* intergenic READ intergenic)

public:
    explicit PositionQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QString getFilter();
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant());
    Q_INVOKABLE void clear();

    inline QuickFilterField* exonic() { return mFields[0]; }
    inline QuickFilterField* intronic() { return mFields[1]; }
    inline QuickFilterField* utr() { return mFields[2]; }
    inline QuickFilterField* intergenic() { return mFields[3]; }

private:
    QList<QuickFilterField*> mFields;
    QString mFilter;
};

#endif // POSITIONQUICKFILTER_H
