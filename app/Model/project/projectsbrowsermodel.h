#ifndef PROJECTSBROWSERMODEL_H
#define PROJECTSBROWSERMODEL_H

#include "Model/treemodel.h"

class ProjectsBrowserModel : public TreeModel
{
    Q_OBJECT
public:

    enum JsonModelRoles
    {
        NameRole = Qt::UserRole + 1,
        DateRole,
        CommentRole,
    };


    explicit ProjectsBrowserModel();
    QHash<int, QByteArray> roleNames() const override;

    QVariant newProjectsBrowserItem(const QString &text, int position);
//    void setupModelData(const QStringList &lines, TreeItem *parent);


private:
    QList<TreeItem*> childItems;
    QVector<QVariant> itemData;
    TreeItem *parentItem;
};

#endif // PROJECTSBROWSERMODEL_H
