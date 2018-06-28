#ifndef FILESTREEMODEL_H
#define FILESTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "file.h"
#include "Model/framework/genericproxymodel.h"

class FilesTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Name,
        Comment,
        Url,
        UpdateDate,
        Size,
        Status,
        Source,
        SearchField
    };

    // Constructors
    FilesTreeModel(QObject* parent=nullptr);
    QHash<int, QByteArray> roleNames() const override;

    // Accessors
    inline bool isLoading() { return mIsLoading; }
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }


    // Methods
    Q_INVOKABLE bool loadJson(const QJsonArray& json);
    Q_INVOKABLE void add(File* file, const QModelIndex& parent=QModelIndex());
    Q_INVOKABLE File* getAt(int row, const QModelIndex& parent=QModelIndex());
    Q_INVOKABLE void clear();


public Q_SLOTS:
    void refreshTreeView();


Q_SIGNALS:
    void neverChanged();
    void isLoadingChanged();

private:
    bool mIsLoading;
    //! The QSortFilterProxyModel to use by table view to browse files of the list
    GenericProxyModel* mProxy = nullptr;
    //! Last time that the list refresh have been called
    QDateTime mLastUpdate;
    //! Keep list of item in the treeview to avoid to add duplicates
    QList<int> mFilesIds;


    // TreeModel method
    void setupModelData(QJsonArray data, TreeItem *parent);
    void add(File* file, TreeItem* parent);
};

#endif // FILESTREEMODEL_H
