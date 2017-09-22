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
public:
    explicit TypeQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QString getFilter();
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant());
    Q_INVOKABLE void clear();
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs);
    bool loadFilter(QJsonArray filter);

    inline QuickFilterField* missense() { return mFields[0]; }
    inline QuickFilterField* nonsense() { return mFields[1]; }
    inline QuickFilterField* splicing() { return mFields[2]; }

private:
    QList<QuickFilterField*> mFields;
    QString mFilter;
    bool mIsVisible;
};

#endif // TYPEQUICKFILTER_H
