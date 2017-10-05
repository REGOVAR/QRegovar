#ifndef FREQUENCEQUICKFILTER_H
#define FREQUENCEQUICKFILTER_H


#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class FrequenceQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(QuickFilterField* _1000GAll READ _1000GAll)
    Q_PROPERTY(QuickFilterField* _1000GAfr READ _1000GAfr)
    Q_PROPERTY(QuickFilterField* _1000GAmr READ _1000GAmr)
    Q_PROPERTY(QuickFilterField* _1000GAsn READ _1000GAsn)
    Q_PROPERTY(QuickFilterField* _1000GEur READ _1000GEur)
    Q_PROPERTY(QuickFilterField* exacAll READ exacAll)
    Q_PROPERTY(QuickFilterField* exacAfr READ exacAfr)
    Q_PROPERTY(QuickFilterField* exacAmr READ exacAmr)
    Q_PROPERTY(QuickFilterField* exacAdj READ exacAdj)
    Q_PROPERTY(QuickFilterField* exacEas READ exacEas)
    Q_PROPERTY(QuickFilterField* exacFin READ exacFin)
    Q_PROPERTY(QuickFilterField* exacNfe READ exacNfe)
    Q_PROPERTY(QuickFilterField* exacSas READ exacSas)

public:
    explicit FrequenceQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant());
    Q_INVOKABLE void clear();
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs);
    bool loadJson(QJsonArray filter);

    inline QuickFilterField* _1000GAll() { return mFields[0]; }
    inline QuickFilterField* _1000GAfr() { return mFields[1]; }
    inline QuickFilterField* _1000GAmr() { return mFields[2]; }
    inline QuickFilterField* _1000GAsn() { return mFields[3]; }
    inline QuickFilterField* _1000GEur() { return mFields[4]; }
    inline QuickFilterField* exacAll() { return mFields[5]; }
    inline QuickFilterField* exacAfr() { return mFields[6]; }
    inline QuickFilterField* exacAmr() { return mFields[7]; }
    inline QuickFilterField* exacAdj() { return mFields[8]; }
    inline QuickFilterField* exacEas() { return mFields[9]; }
    inline QuickFilterField* exacFin() { return mFields[10]; }
    inline QuickFilterField* exacNfe() { return mFields[11]; }
    inline QuickFilterField* exacSas() { return mFields[12]; }


private:
    QList<QuickFilterField*> mFields;
    QString mFilter;
    QStringList mOperators;
    QHash<QString, QString> mOpMapping;

    bool mIsVisible;
};

#endif // FREQUENCEQUICKFILTER_H
