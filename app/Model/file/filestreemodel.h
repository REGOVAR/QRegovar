#ifndef FILESTREEMODEL_H
#define FILESTREEMODEL_H

#include "Model/framework/treemodel.h"

class FilesTreeModel : public TreeModel
{
    Q_OBJECT
public:

    enum JsonModelRoles
    {
        NameRole = Qt::UserRole + 1,
        StatusRole,
        SizeRole,
        DateRole,
        CommentRole,
    };



    explicit FilesTreeModel();
    QHash<int, QByteArray> roleNames() const override;

    void refresh();
    QVariant newFilesTreeViewItem(int id, const QString &text);
    QVariant newFilesTreeViewItemSize(int id, quint64 size, quint64 offset);
    QVariant newFilesTreeViewItemStatus(int id, QString status, quint64 size, quint64 offset);

    void setupModelData(QJsonArray data, TreeItem *parent);

    bool fromJson(QJsonArray json);
    QString humanSize(qint64 nbytes);
};

#endif // FILESTREEMODEL_H
