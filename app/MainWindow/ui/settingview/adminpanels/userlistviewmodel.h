#ifndef USERLISTVIEWMODEL_H
#define USERLISTVIEWMODEL_H

#include <QAbstractListModel>
#include "model/usermodel.h"
#include "tools/request.h"

class UserListViewModel :  public QAbstractListModel
{
    Q_OBJECT
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

    // Constructor
    UserListViewModel(QObject* parent=nullptr);

    // Overriden methods
    int rowCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    int columnCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const Q_DECL_OVERRIDE;

    // Methods
    void deleteUser(UserModel* user);
    void deleteUser(quint32 userId);
    void saveUser(UserModel* user);
    UserModel* createUser();
    void refresh();



    // Accessor
    UserModel* at(int index);



Q_SIGNALS:
    void addRequestSuccess();
    void addRequestFailed();
    void editRequestSuccess();
    void editRequestFailed();
    void deleteRequestSuccess();
    void deleteRequestFailed();



private:
    QList<UserModel*> mUsers;


};

#endif // USERLISTVIEWMODEL_H
