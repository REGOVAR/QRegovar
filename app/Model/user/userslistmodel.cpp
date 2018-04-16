#include "userslistmodel.h"
#include "Model/regovar.h"

UsersListModel::UsersListModel(QObject *parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Lastname);
}




bool UsersListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mUsersList.clear();
    for (const QJsonValue& userJson: json)
    {
        QJsonObject userData = userJson.toObject();
        User* user = regovar->usersManager()->getOrCreateUser(userData["id"].toInt());
        user->loadJson(userData);
        if (!mUsersList.contains(user))
        {
            mUsersList.append(user);
        }
    }
    endResetModel();
    emit countChanged();
    return true;
}



bool UsersListModel::append(User* user)
{
    if (!mUsersList.contains(user))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mUsersList.append(user);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}



bool UsersListModel::refresh()
{
    qDebug() << "TODO: UsersListModel::refresh()";
    return false;
}




int UsersListModel::rowCount(const QModelIndex&) const
{
    return mUsersList.count();
}



QVariant UsersListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mUsersList.count())
        return QVariant();

    const User* user= mUsersList[index.row()];
    if (role == Login || role == Qt::DisplayRole)
        return user->login();
    else if (role == Id)
        return user->id();
    else if (role == Firstname)
        return user->firstname();
    else if (role == Lastname)
        return user->lastname();
    else if (role == Email)
        return user->email();
    else if (role == Function)
        return user->function();
    else if (role == Location)
        return user->location();
    else if (role == CreationDate)
        return regovar->formatDate(user->creationDate());
    else if (role == LastActivity)
        return regovar->formatDate(user->lastActivity());
    else if (role == IsActive)
        return user->isActive();
    else if (role == IsAdmin)
        return user->isAdmin();
    else if (role == SearchField)
        return user->searchField();
    return QVariant();
}



QHash<int, QByteArray> UsersListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Firstname] = "firstname";
    roles[Lastname] = "lastname";
    roles[Email] = "email";
    roles[Login] = "login";
    roles[Function] = "function";
    roles[Location] = "location";
    roles[CreationDate] = "creationDate";
    roles[LastActivity] = "lastActivity";
    roles[IsActive] = "isActive";
    roles[IsAdmin] = "isAdmin";
    roles[SearchField] = "searchField";
    return roles;
}

