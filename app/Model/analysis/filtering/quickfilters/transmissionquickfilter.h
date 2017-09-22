#ifndef TRANSMISSIONQUICKFILTER_H
#define TRANSMISSIONQUICKFILTER_H

#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class TransmissionQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(bool isTrio READ isTrio WRITE setIsTrio NOTIFY isTrioChanged)


public:
    explicit TransmissionQuickFilter(int);

    // QuickFilterBlockInterface implementation
    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QString getFilter();
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant());
    Q_INVOKABLE void clear();
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*>);
    bool loadFilter(QJsonArray filter);

    // Getters
    inline bool isTrio() { return mIsTrio; }

    // Setters
    inline void setIsTrio(bool isTrio) { mIsTrio=isTrio; emit isTrioChanged(); }


Q_SIGNALS:
    void isTrioChanged();


private:
    QHash<QString, QString> mFilters;
    QHash<QString, bool> mActiveFilters;
    bool mIsTrio;
};

#endif // TRANSMISSIONQUICKFILTER_H
