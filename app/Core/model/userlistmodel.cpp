#include "userlistmodel.h"
#include "tools/request.h"



UserListModel::UserListModel(QObject* parent) : QAbstractListModel(parent)
{
    Request* req = Request::get("/users");
    connect(req, &Request::jsonReceived, [this, req](const QJsonObject& json)
    {
        if (json["success"].toBool())
        {
            beginResetModel();
            for(QJsonValue  u: json["data"].toArray())
            {
                UserModel* newUser = new UserModel;
                newUser->fromJson(u.toObject());
                mUsers.append(newUser);
            }
            endResetModel();
            qDebug() << "UserListmodel with " << mUsers.size() << "users";
        }
        else
        {
            qDebug() << "Unable to build user list model (request error)";
        }
    });
}







int UserListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mUsers.size();
}

int UserListModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 7;
}

QVariant UserListModel::data(const QModelIndex &index, int role) const
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
// wtf qt... it's not the job of the model to give ui reprensation of data....
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

QVariant UserListModel::headerData(int section, Qt::Orientation orientation, int role) const
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

