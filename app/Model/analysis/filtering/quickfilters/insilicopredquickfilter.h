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
    Q_PROPERTY(QuickFilterField* impact READ impact)
public:
    InSilicoPredQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible() override;
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant()) override;
    Q_INVOKABLE void clear() override;
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs) override;
    bool loadJson(QJsonArray filter) override;
    void init(QString siftUid, QString polyUid, QString caddUid, QString impactUid);


    inline QuickFilterField* sift() { return mFields.count() > 0 ? mFields[0] : nullptr; }
    inline QuickFilterField* polyphen() { return mFields.count() > 1 ? mFields[1] : nullptr; }
    inline QuickFilterField* cadd() { return mFields.count() > 2 ? mFields[2] : nullptr; }
    inline QuickFilterField* impact() { return mFields.count() > 3 ? mFields[3] : nullptr; }


private:
    QList<QuickFilterField*> mFields;
    QStringList mOperators;
};


#endif // INSILICOPREDQUICKFILTER_H
