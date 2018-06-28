#ifndef RESULTSTREEMODEL_H
#define RESULTSTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "Model/framework/treeitem.h"
#include "filteringanalysis.h"
#include "annotation.h"

class FilteringAnalysis;

class ResultsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(int total READ total WRITE setTotal NOTIFY totalChanged)
    Q_PROPERTY(int loaded READ loaded WRITE setLoaded NOTIFY loadedChanged)
    Q_PROPERTY(QString samplesNames READ samplesNames NOTIFY samplesNamesChanged)

public:
    // Constructors
    ResultsTreeModel(FilteringAnalysis* parent=nullptr);

    // QAbstractItemModel interface - lazy loading methods
    QHash<int, QByteArray> roleNames() const override;
    bool canFetchMore(const QModelIndex &parent) const override;
    void fetchMore(const QModelIndex& parent) override;
    bool hasChildren(const QModelIndex &parent) const override;

    // Getters
    inline bool isLoading() const { return mIsLoading; }
    inline int total() const { return mTotal; }
    inline int loaded() const { return mLoaded; }
    inline QString samplesNames() const { return mSamplesNames; }

    // Setters
    Q_INVOKABLE inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); qDebug() << "ISLOADING" << isLoading;}
    inline void setTotal(int total) { mTotal = total; emit totalChanged(); }
    inline void setLoaded(int loaded) { mLoaded = loaded; emit loadedChanged(); }


    // Methods
    //! Force the Treemodel to reload data according to the provided filter
    Q_INVOKABLE void applyFilter(QJsonArray filter);
    //! Force the Treemodel to reload data according to the analysis selection
    Q_INVOKABLE void applySelection();
    //! To use when new columns have been added, to add info in the model without reseting it
    Q_INVOKABLE void reload();
    //! Load next results according to the mResultsPagination value (default is 1000)
    Q_INVOKABLE void loadNext();
    //! Load all results
    Q_INVOKABLE void loadAll();
    //! Method that update treemodel with data returned by the server (called by applyFilter or applySelection)
    void loadResults(QJsonObject data);

    // Q_INVOKABLE QVariantList getData(int index);


    void initAnalysisData(int analysisId);
    void setupModelData(QJsonArray data, TreeItem *parent);
    TreeItem* newResultsTreeViewItem(const QJsonObject& rowData);


Q_SIGNALS:
    void isLoadingChanged();
    void totalChanged();
    void loadedChanged();
    void samplesNamesChanged();

private:
    FilteringAnalysis* mFilteringAnalysis = nullptr;
    bool mIsLoading = false;
    int mAnalysisId = -1;
    int mTotal = 0;
    int mLoaded = 0;
    int mPagination = 0;
    QHash<int, QByteArray> mRoles;
    QString mSamplesNames;

    bool mAutoLoadingNext = false;
    int mPaginationMax = 0;
};

#endif // RESULTSTREEMODEL_H
