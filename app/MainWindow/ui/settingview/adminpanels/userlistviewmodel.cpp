#include "userlistviewmodel.h"




UserListViewModel::UserListViewModel(QObject* parent) : QAbstractListModel(parent)
{
    refresh();
}






// Overriden methods ===========================================================

int UserListViewModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mUsers.size();
}

int UserListViewModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 7;
}

QVariant UserListViewModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        return QVariant();
    }


    if ( role == Qt::DisplayRole)
    {
        switch(index.column())
        {
            case LoginColumn:    return mUsers.at(index.row())->login();
            case LastnameColumn: return mUsers.at(index.row())->lastname();
            case FirstnameColumn:    return mUsers.at(index.row())->firstname();
            case EmailColumn: return mUsers.at(index.row())->email();
            case FunctionColumn:    return mUsers.at(index.row())->function();
            case LocationColumn: return mUsers.at(index.row())->location();
            case LastUpdateColumn: return mUsers.at(index.row())->lastActivity();
        }
    }

//    if (role == Qt::DecorationRole && index.column() == MessageColumn)
//    {
//        switch (mEvents.at(index.row())->type())
//        {
//            case Info : return QFontIcon::icon(0xf017, Qt::darkGray); break;
//            case Warning: return QFontIcon::icon(0xf071,Qt::darkRed); break;
//            case Error : return QFontIcon::icon(0xf085,Qt::darkGray); break;
//            case Success: return QFontIcon::icon(0xf00c,Qt::darkGreen); break;
//        }
//    }
//    if (role == Qt::TextColorRole)
//    {
//        if (mEvents.at(index.row())->type() == Error)
//        {
//            return QColor(Qt::red);
//        }
//        if (index.column() == MessageColumn)
//        {
//            switch (mRunners.at(index.row())->status())
//            {
//            case Info : return QColor(Qt::lightGray); break;
//            case Error: return QColor(Qt::darkRed); break;
//            case Success: return QColor(Qt::darkGreen); break;
//            default: break;
//            }
//        }
//        return qApp->palette("QWidget").text().color();
//    }


    return QVariant();

}

QVariant UserListViewModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal)
    {
        switch (section)
        {
            case LoginColumn : return tr("Login");break;
            case LastnameColumn: return tr("Lastname");break;
            case FirstnameColumn: return tr("Firstname"); break;
            case EmailColumn: return tr("Email"); break;
            case FunctionColumn: return tr("Function"); break;
            case LocationColumn: return tr("Location"); break;
            case LastUpdateColumn: return tr("Last update"); break;
        }
    }
    return QVariant();
}







// Methods ===========================================================


void UserListViewModel::deleteUser(UserModel* user)
{

}

void UserListViewModel::deleteUser(quint32 userId)
{
    Request* request = Request::del(QString("/users/%1").arg(userId));
    connect(request, &Request::responseReceived, [this, request, userId](bool success, const QJsonObject& json)
    {
        if (success)
        {
            for (int idx=0; idx < mUsers.size(); idx++)
            {
                UserModel* user = mUsers.at(idx);
                if (user->id() == userId)
                {
                    beginRemoveRows(index(1), idx, idx+1);
                    mUsers.removeAt(idx);
                    endRemoveRows();
                    qDebug() << Q_FUNC_INFO << "User deleted on server, client updated";
                    emit deleteRequestSuccess();
                    break;
                }
            }
        }
        else
        {
            emit deleteRequestFailed();
            qCritical() << Q_FUNC_INFO << "Unable to delete user server side";
        }
        request->deleteLater();
    });
}

void UserListViewModel::saveUser(UserModel* user)
{

}

UserModel* UserListViewModel::createUser()
{
    UserModel* newUser = new UserModel;
    beginInsertRows(index(1),mUsers.size(),mUsers.size()+1);
    mUsers.append(newUser);
    endInsertRows();
    return newUser;
}


void UserListViewModel::refresh()
{
    Request* request = Request::get("/users");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            beginResetModel();
            for(QJsonValue  u: json["data"].toArray())
            {
                UserModel* newUser = new UserModel;
                newUser->fromJson(u.toObject());
                mUsers.append(newUser);
            }
            endResetModel();
            qDebug() << Q_FUNC_INFO << "UserListmodel with " << mUsers.size() << "users";
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build user list model (due to request error)";
        }
        request->deleteLater();
    });
}





// Accessor ===========================================================

UserModel* UserListViewModel::at(int index)
{
    if (index >= 0 && index < mUsers.size() )
    {
        return mUsers.at(index);
    }
    return nullptr;
}
