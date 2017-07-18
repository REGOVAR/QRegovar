#ifndef PROJECTSTREEVIEWMODEL_H
#define PROJECTSTREEVIEWMODEL_H

#include "Model/treemodel.h"

class ProjectsTreeViewModel : public TreeModel
{
    Q_OBJECT
public:

    enum JsonModelRoles
    {
        NameRole = Qt::UserRole + 1,
        CommentRole,
        DateRole,
    };


    explicit ProjectsTreeViewModel();
    QHash<int, QByteArray> roleNames() const override;

    void refresh();
    QVariant newProjectsTreeViewItem(int id, const QString &text);
    void setupModelData(QJsonArray data, TreeItem *parent);
};

#endif // PROJECTSTREEVIEWMODEL_H
