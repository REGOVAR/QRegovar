#ifndef USERLISTMODEL_H
#define USERLISTMODEL_H

#include <QAbstractListModel>
#include "usermodel.h"

class UserListModel :  public QAbstractListModel
{
public:
    enum
    {
        LoginColumn = 0,
        LastnameColumn,
        FirstnameColumn,
        EmailColumn,
        FunctionColumn,
        LocationColumn,
        LastUpdateColumn
    };

    UserListModel(QObject* parent=nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    int columnCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const Q_DECL_OVERRIDE;


private:
    QList<UserModel*> mUsers;
};

#endif // USERLISTMODEL_H
