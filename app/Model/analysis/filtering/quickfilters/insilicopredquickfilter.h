#ifndef INSILICOPREDQUICKFILTER_H
#define INSILICOPREDQUICKFILTER_H


#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class InSilicoPredQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(QuickFilterField* sift READ sift)
    Q_PROPERTY(QuickFilterField* polyphen READ polyphen)
    Q_PROPERTY(QuickFilterField* cadd READ cadd)
public:
    InSilicoPredQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QString getFilter();
    Q_INVOKABLE void setFilter(int id, QVariant value);
    Q_INVOKABLE void clear();


    inline QuickFilterField* sift() { return mFields[0]; }
    inline QuickFilterField* polyphen() { return mFields[1]; }
    inline QuickFilterField* cadd() { return mFields[2]; }


private:
    QList<QuickFilterField*> mFields;
    QString mFilter;
};


#endif // INSILICOPREDQUICKFILTER_H
