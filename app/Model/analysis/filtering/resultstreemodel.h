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
    Q_PROPERTY(QStringList samples READ samples NOTIFY samplesUpdated)

public:
    explicit ResultsTreeModel(FilteringAnalysis* parent=nullptr);
    QHash<int, QByteArray> roleNames() const override;


    Q_INVOKABLE void refresh();
    QVariant newResultsTreeViewItem(Annotation* annot, QString uid, const QVariant &value);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void loadAnalysisData();
    void initAnalysisData(int analysisId);
    bool fromJson(QJsonObject json);

    // Getters
    inline bool isLoading() { return mIsLoading; }
    inline QStringList samples() { return mSamples; }

    // Setters
    Q_INVOKABLE inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingUpdated(); }




Q_SIGNALS:
    void isLoadingUpdated();
    void samplesUpdated();

private:
    FilteringAnalysis* mFilteringAnalysis;
    bool mIsLoading;
    QStringList mSamples;

    int mAnalysisId;


};

#endif // RESULTSTREEMODEL_H
