#ifndef RESULTSTREEMODEL_H
#define RESULTSTREEMODEL_H

#include "Model/treemodel.h"
#include "filteringanalysis.h"
#include "annotation.h"

class FilteringAnalysis;

class ResultsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingUpdated)

public:
    explicit ResultsTreeModel(FilteringAnalysis* parent=nullptr);
    QHash<int, QByteArray> roleNames() const override;


    /* QAbstractItemModel interface - lazy loading methods */
//    bool hasChildren(const QModelIndex &parent) const Q_DECL_OVERRIDE;
//    bool canFetchMore(const QModelIndex &parent) const Q_DECL_OVERRIDE;
//    void fetchMore(const QModelIndex& parent) Q_DECL_OVERRIDE;


    Q_INVOKABLE void refresh();
    QVariant newResultsTreeViewItem(Annotation* annot, QString uid, const QJsonValue &value);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void loadAnalysisData();
    void initAnalysisData(int analysisId);
    bool fromJson(QJsonObject json);

    // Getters
    inline bool isLoading() { return mIsLoading; }

    // Setters
    Q_INVOKABLE inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingUpdated(); }




Q_SIGNALS:
    void isLoadingUpdated();

private:
    FilteringAnalysis* mFilteringAnalysis;
    bool mIsLoading;

    int mAnalysisId;


};

#endif // RESULTSTREEMODEL_H
