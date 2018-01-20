#ifndef PROJECTSTREEMODEL_H
#define PROJECTSTREEMODEL_H

#include "Model/framework/treemodel.h"

class ProjectsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)

public:
    enum JsonModelRoles
    {
        IdRole = Qt::UserRole + 1,
        TypeRole,
        NameRole,
        CommentRole,
        DateRole,
    };

    // Constructor
    explicit ProjectsTreeModel();

    // Getters
    inline bool isLoading() { return mIsLoading; }

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }

    // Methods
    QHash<int, QByteArray> roleNames() const override;
    void refresh(QJsonObject json);
    TreeItem* newProjectsTreeItem(bool isFolder, const QJsonObject& rowData, TreeItem* parent);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void setupModelAnalysisData(QJsonArray data, TreeItem *parent);

Q_SIGNALS:
    void isLoadingChanged();


private:
    bool mIsLoading;
};

#endif // PROJECTSTREEMODEL_H
