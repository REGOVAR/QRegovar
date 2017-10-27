#ifndef REMOTESAMPLETREEMODEL_H
#define REMOTESAMPLETREEMODEL_H

#include "Model/framework/treemodel.h"
#include "filteringanalysis.h"

class FilteringAnalysis;

class RemoteSampleTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)

public:
    enum ColumnRole
    {
        // technical columns (hidden)
        sampleIdRole = Qt::UserRole + 1,
        subjectIdRole,
        fileIdRole,
        // info columns
        nameRole,
        commentRole,
        statusRole,
        filenameRole,
        importDateRole,
        firstnameRole,
        lastnameRole,
        sexRole,
        birthdayRole,
        deathdayRole
    };

    explicit RemoteSampleTreeModel(FilteringAnalysis* parent=nullptr);

    QHash<int, QByteArray> roleNames() const override;

    // Getters
    inline bool isLoading() { return mIsLoading; }

    // Setters
    Q_INVOKABLE inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }


    // Methods
    QVariant newRemoteSampleTreeViewItem(int sampleId, int subjectId, int fileId, const QJsonValue &value);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void loadAnalysisData();
    void reset();


Q_SIGNALS:
    void isLoadingChanged();

private:
    FilteringAnalysis* mFilteringAnalysis = nullptr;
    QHash<int, QByteArray> mRoles;
    bool mIsLoading;
};

#endif // REMOTESAMPLETREEMODEL_H
