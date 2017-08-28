#ifndef REMOTESAMPLETREEMODEL_H
#define REMOTESAMPLETREEMODEL_H

#include "Model/treemodel.h"
#include "filteringanalysis.h"

class FilteringAnalysis;

class RemoteSampleTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)

public:

    explicit RemoteSampleTreeModel(FilteringAnalysis* parent=nullptr);

    QHash<int, QByteArray> roleNames() const override;

    // Getters
    inline bool isLoading() { return mIsLoading; }

    // Setters
    Q_INVOKABLE inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }


    // Methods
    QVariant newRemoteSampleTreeViewItem(Annotation* annot, QString uid, const QJsonValue &value);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void loadAnalysisData();
    void reset();


Q_SIGNALS:
    void isLoadingChanged();

private:
    FilteringAnalysis* mFilteringAnalysis;
    QHash<int, QByteArray> mRoles;
    bool mIsLoading;
};

#endif // REMOTESAMPLETREEMODEL_H
