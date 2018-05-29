#ifndef POSITIONQUICKFILTER_H
#define POSITIONQUICKFILTER_H



#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class PositionQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(QuickFilterField* exonic READ exonic)
    Q_PROPERTY(QuickFilterField* intronic READ intronic)
    Q_PROPERTY(QuickFilterField* utr READ utr)
    Q_PROPERTY(QuickFilterField* intergenic READ intergenic)
    Q_PROPERTY(QuickFilterField* splice READ splice)

public:
    // Constructors
    PositionQuickFilter(int analysisId);

    // Methods
    Q_INVOKABLE bool isVisible() override;
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant()) override;
    Q_INVOKABLE void clear() override;
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs) override;
    bool loadJson(QJsonArray filter) override;
    void init(QString fuid);

    inline QuickFilterField* exonic() { return mFields[0]; }
    inline QuickFilterField* intronic() { return mFields[3]; }
    inline QuickFilterField* utr() { return mFields[4]; }
    inline QuickFilterField* intergenic() { return mFields[6]; }
    inline QuickFilterField* splice() { return mFields[9]; }

private:
    QList<QuickFilterField*> mFields;
};

#endif // POSITIONQUICKFILTER_H
