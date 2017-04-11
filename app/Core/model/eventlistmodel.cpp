#include "eventlistmodel.h"



EventListModel::EventListModel(QObject* parent) : QAbstractListModel(parent)
{
    mEvents = new QList<EventModel>();
    mEvents->append(EventModel(1, QDateTime::currentDateTime(), Info, "Coucou", nullptr));
    mEvents->append(EventModel(2, QDateTime::currentDateTime(), Info, "Test", nullptr));
    mEvents->append(EventModel(3, QDateTime::currentDateTime(), Warning, "Attention !", nullptr));
    mEvents->append(EventModel(4, QDateTime::currentDateTime(), Success, "Yes :)", nullptr));
}




int EventListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mEvents->size();
}

int EventListModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 3;
}

QVariant EventListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        return QVariant();
    }


    if ( role == Qt::DisplayRole)
    {
        switch(index.column())
        {
            case DateColumn:    return mEvents->at(index.row()).date();
            case MessageColumn: return mEvents->at(index.row()).message();
            case UserColumn:
                UserModel* user = mEvents->at(index.row()).user();
                if (user != nullptr)
                {
                    return QString("%1 %2").arg(user->firstname().toUpper(), user->lastname());
                }
                break;
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

QVariant EventListModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal)
    {
        switch (section)
        {
            case DateColumn : return tr("Date");break;
            case MessageColumn: return tr("Message");break;
            case UserColumn: return tr("User"); break;
        }
    }
    return QVariant();
}


