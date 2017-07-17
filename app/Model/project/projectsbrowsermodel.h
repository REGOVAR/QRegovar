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
        CommentRole,
        DateRole,
    };


    explicit ProjectsBrowserModel();
    QHash<int, QByteArray> roleNames() const override;

    void refresh();
    QVariant newProjectsBrowserItem(int id, const QString &text);
    void setupModelData(QJsonArray data, TreeItem *parent);

    //Q_INVOKABLE ProjectModel* getProject(const QModelIndex &index);

};

#endif // PROJECTSBROWSERMODEL_H
