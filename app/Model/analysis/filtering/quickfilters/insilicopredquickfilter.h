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
    Q_INVOKABLE QJsonArray toJson();
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant());
    Q_INVOKABLE void clear();
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs);
    bool loadJson(QJsonArray filter);
    void init(QString siftUid, QString polyUid, QString caddUid);


    inline QuickFilterField* sift() { return mFields[0]; }
    inline QuickFilterField* polyphen() { return mFields[1]; }
    inline QuickFilterField* cadd() { return mFields[2]; }


private:
    QList<QuickFilterField*> mFields;
    QStringList mOperators;
    bool mIsVisible;
};


#endif // INSILICOPREDQUICKFILTER_H
