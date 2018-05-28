#ifndef PROJECTSTREEMODEL_H
#define PROJECTSTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "Model/analysis/analysis.h"

class ProjectsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)

public:
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Type,
        AnalysisType,
        Name,
        Comment,
        Date,
        Status,
        SearchField
    };

    // Constructor
    explicit ProjectsTreeModel(QObject* parent=nullptr);

    // Getters
    inline bool isLoading() { return mIsLoading; }

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }

    // Methods
    QHash<int, QByteArray> roleNames() const override;
    bool loadJson(QJsonArray json);
    void setupModelData(QJsonArray data, TreeItem *parent);
    TreeItem* newFolderTreeItem(const QJsonObject& data, TreeItem* parent);
    TreeItem* newAnalysisTreeItem(const Analysis* analysis, TreeItem* parent);

Q_SIGNALS:
    void isLoadingChanged();


private:
    bool mIsLoading;
};

#endif // PROJECTSTREEMODEL_H
