#ifndef QUICKFILTERMODEL_H
#define QUICKFILTERMODEL_H

#include <QObject>
#include <QHash>
#include <QVariant>
#include "quickfilterblockinterface.h"


class QuickFilterModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QuickFilterBlockInterface* transmissionFilter READ transmissionFilter NOTIFY filterUpdated)


public:
    enum PredefinedFilter
    {
        TransmissionFilter
    };

    explicit QuickFilterModel(QObject *parent = nullptr);
    void init(int refId, int analysisId);
    Q_INVOKABLE void clear();

    // Getters
    inline QuickFilterBlockInterface* transmissionFilter() { return mQuickFilters[TransmissionFilter]; }


    // Methods
    Q_INVOKABLE QString getFilter();
    Q_INVOKABLE void setFilter(PredefinedFilter filter, int fieldId, QVariant value);

Q_SIGNALS:
    void filterUpdated();



private:
    QHash<PredefinedFilter, QuickFilterBlockInterface*> mQuickFilters;
};

#endif // QUICKFILTERMODEL_H
