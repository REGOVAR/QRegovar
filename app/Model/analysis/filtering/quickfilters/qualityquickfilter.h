#ifndef QUALITYQUICKFILTER_H
#define QUALITYQUICKFILTER_H


#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"



class QualityQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT

    Q_PROPERTY(QuickFilterField* depth READ depth NOTIFY depthChanged)

public:
    QualityQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QString getFilter();
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant());
    Q_INVOKABLE void clear();

    // Getters
    inline QuickFilterField* depth() { return mDepth; }


Q_SIGNALS:
    void depthChanged();


private:
    QuickFilterField* mDepth;
    QString mFilter;
};


#endif // QUALITYQUICKFILTER_H
