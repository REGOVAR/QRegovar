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
    // Constructor
    TypeQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible() override;
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant()) override;
    Q_INVOKABLE void clear() override;
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs) override;
    bool loadJson(QJsonArray filter) override;
    void init(QString fuid);

    inline QuickFilterField* missense()   { return mIsVisible ? mFields[0] : nullptr; }
    inline QuickFilterField* nonsense()   { return mIsVisible ? mFields[1] : nullptr; }
    inline QuickFilterField* splicing()   { return mIsVisible ? mFields[2] : nullptr; }
    inline QuickFilterField* indel()      { return mIsVisible ? mFields[4] : nullptr; }
    inline QuickFilterField* synonymous() { return mIsVisible ? mFields[7] : nullptr; }

private:
    QList<QuickFilterField*> mFields;
};

#endif // TYPEQUICKFILTER_H
