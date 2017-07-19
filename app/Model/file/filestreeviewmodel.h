#ifndef FILESTREEVIEWMODEL_H
#define FILESTREEVIEWMODEL_H

#include "Model/treemodel.h"

class FilesTreeViewModel : public TreeModel
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



    explicit FilesTreeViewModel();
    QHash<int, QByteArray> roleNames() const override;

    void refresh();
    QVariant newFilesTreeViewItem(int id, const QString &text);
    QVariant newFilesTreeViewItemSize(int id, quint64 size, quint64 offset);
    QVariant newFilesTreeViewItemStatus(int id, QString status, quint64 size, quint64 offset);

    void setupModelData(QJsonArray data, TreeItem *parent);

    bool fromJson(QJsonArray json);
    QString humanSize(qint64 nbytes);
};

#endif // FILESTREEVIEWMODEL_H
