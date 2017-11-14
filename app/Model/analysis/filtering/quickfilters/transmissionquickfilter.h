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
    Q_INVOKABLE bool isVisible() override;
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant()) override;
    Q_INVOKABLE void clear() override;
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*>) override;
    bool loadJson(QJsonArray filter) override;

    // Getters
    inline bool isTrio() { return mIsTrio; }

    // Setters
    inline void setIsTrio(bool isTrio) { mIsTrio=isTrio; emit isTrioChanged(); }


Q_SIGNALS:
    void isTrioChanged();


private:
    QHash<QString, QuickFilterField*> mFilters;
    bool mIsTrio;
};

#endif // TRANSMISSIONQUICKFILTER_H
