#ifndef TYPEQUICKFILTER_H
#define TYPEQUICKFILTER_H



#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class TypeQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(QuickFilterField* missense READ missense)
    Q_PROPERTY(QuickFilterField* nonsense READ nonsense)
    Q_PROPERTY(QuickFilterField* splicing READ splicing)
    Q_PROPERTY(QuickFilterField* indel READ indel)
    Q_PROPERTY(QuickFilterField* synonymous READ synonymous)
public:
    explicit TypeQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant());
    Q_INVOKABLE void clear();
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs);
    bool loadJson(QJsonArray filter);
    void init(QString fuid);

    inline QuickFilterField* missense()   { return mFields[0]; }
    inline QuickFilterField* nonsense()   { return mFields[1]; }
    inline QuickFilterField* splicing()   { return mFields[2]; }
    inline QuickFilterField* indel()      { return mFields[4]; }
    inline QuickFilterField* synonymous() { return mFields[7]; }

private:
    QList<QuickFilterField*> mFields;
    bool mIsVisible;
};

#endif // TYPEQUICKFILTER_H
