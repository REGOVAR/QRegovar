#ifndef DOCUMENTSTREEMODEL_H
#define DOCUMENTSTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "documentstreeitem.h"
#include "filteringanalysis.h"

class FilteringAnalysis;

class DocumentsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)

public:
    enum JsonModelRoles
    {
        Info =  Qt::UserRole + 1,
        Name,
        Size,
        Date,
        Comment,
    };

    // Constructor
    DocumentsTreeModel(FilteringAnalysis* parent=nullptr);
    QHash<int, QByteArray> roleNames() const override;


    Q_INVOKABLE void refresh(QJsonObject json);

    // Accessors
    inline bool isLoading() { return mIsLoading; }

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }


Q_SIGNALS:
    void isLoadingChanged();


private:
    bool mIsLoading;


    DocumentsTreeItem* newFileTreeViewItem(QJsonObject data, TreeItem* parent);
    DocumentsTreeItem* newSampleTreeViewItem(QJsonObject data, TreeItem* parent);
    void setupModelData(QJsonObject data, TreeItem *parent);

};

#endif // DOCUMENTSTREEMODEL_H
