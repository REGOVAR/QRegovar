#ifndef FILTERINGRESULT_H
#define FILTERINGRESULT_H

#include <QtCore>
#include "filteringanalysis.h"

/*
class FilteringResult: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(bool loading READ loading WRITE setLoading NOTIFY loadingChanged)
    Q_PROPERTY(int total READ total WRITE setTotal NOTIFY totalChanged)
    Q_PROPERTY(int loaded READ loaded WRITE setLoaded NOTIFY loadedChanged)



public:

    enum FilteringResultRoles
    {
        Id = Qt::UserRole + 1,
        IsSelected,
        Level,
        Children,
        Data
    };

    // Constructors
    FilteringResult(FilteringAnalysis* parent=nullptr);

    // Getters
    inline bool loading() { return mLoading; }
    inline int total() { return mTotal; }
    inline int loaded() { return mLoaded; }

    // Setters
    Q_INVOKABLE inline void setLoading(bool loading) { mLoading = loading; emit loadingChanged(); qDebug() << "ISLOADING" << isLoading;}
    inline void setTotal(int total) { mTotal = total; emit totalChanged(); }
    inline void setLoaded(int loaded) { mLoaded = loaded; emit loadedChanged(); }

    // Methods
    //! Force the Treemodel to reload data according to the provided filter
    Q_INVOKABLE void applyFilter(QJsonArray filter);
    //! Load next results according to the mResultsPagination value (default is 1000)
    Q_INVOKABLE void loadNext();

    void initAnalysisData(int analysisId);
    void setupModelData(QJsonArray data, TreeItem *parent);
    TreeItem* newFilteringResultItem(const QJsonObject& rowData);


Q_SIGNALS:
    void loadingChanged();
    void totalChanged();
    void loadedChanged();

private:
    FilteringAnalysis* mFilteringAnalysis = nullptr;
    bool mLoading = false;
    int mAnalysisId = -1;
    int mTotal = 0;
    int mLoaded = 0;
    int mPagination = 0;
    QHash<int, QByteArray> mCellsRoles;

    bool mAutoLoadingNext = false;
    int mPaginationMax = 0;
};
*/
#endif // FILTERINGRESULT_H
