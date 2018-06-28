#ifndef PANELQUICKFILTER_H
#define PANELQUICKFILTER_H

#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class PanelQuickFilter: public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> panelsList READ panelsList NOTIFY panelsListChanged)

public:
    // Constructor
    PanelQuickFilter(int analysisId);

    // Methods overrided
    Q_INVOKABLE bool isVisible() override;
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(const QString& filterId, bool filterActive, QVariant filterValue=QVariant()) override;
    Q_INVOKABLE void clear() override;
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs) override;
    bool loadJson(const QJsonArray& filter) override;

    // Getters
    inline QList<QObject*> panelsList() const { return mPanelsList; }


Q_SIGNALS:
    void panelsListChanged();

private:
    QStringList mOperators;
    QList<QObject*> mPanelsList;
};

#endif // PANELQUICKFILTER_H
