#ifndef QUALITYQUICKFILTER_H
#define QUALITYQUICKFILTER_H


#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"



class QualityQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT

    Q_PROPERTY(QuickFilterField* depth READ depth NOTIFY depthChanged)
    Q_PROPERTY(QuickFilterField* vaf READ vaf NOTIFY vafChanged)

public:
    QualityQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible() override;
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant()) override;
    Q_INVOKABLE void clear() override;
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs) override;
    bool loadJson(QJsonArray filter) override;

    // Getters
    inline QuickFilterField* depth() { return mDepth; }
    inline QuickFilterField* vaf() { return mVaf; }


Q_SIGNALS:
    void depthChanged();
    void vafChanged();


private:
    QuickFilterField* mDepth = nullptr;
    QuickFilterField* mVaf = nullptr;
    QStringList mOperators;
};


#endif // QUALITYQUICKFILTER_H
