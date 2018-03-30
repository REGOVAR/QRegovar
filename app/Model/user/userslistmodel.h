#ifndef USERSLISTMODEL_H
#define USERSLISTMODEL_H

#include <QtCore>
#include "user.h"
#include "Model/framework/genericproxymodel.h"

class UsersListModel : public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Firstname,
        Lastname,
        Email,
        Login,
        Function,
        Location,
        CreationDate,
        LastActivity,
        IsActive,
        IsAdmin,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructor
    explicit UsersListModel(QObject* parent = nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    Q_INVOKABLE bool loadJson(QJsonArray json);
    Q_INVOKABLE bool add(User* user);
    Q_INVOKABLE bool refresh();

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();

private:
    //! List of users
    QList<User*> mUsersList;
    //! The QSortFilterProxyModel to use by table view to browse users of the list
    GenericProxyModel* mProxy = nullptr;
    //! Last time that the user list have been refreshed
    QDateTime mLastUpdate;
};

#endif // USERSLISTMODEL_H
