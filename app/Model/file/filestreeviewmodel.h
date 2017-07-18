#ifndef FILESBROWSERMODEL_H
#define FILESBROWSERMODEL_H

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
    QVariant newFilesBrowserItem(int id, const QString &text, qint64 size=-1, qint64 uploadOffset=-1);
    void setupModelData(QJsonArray data, TreeItem *parent);
};

#endif // FILESBROWSERMODEL_H
