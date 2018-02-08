#include "menuentrymodel.h"

int MenuEntryModel::sUID = 0;

MenuEntryModel::MenuEntryModel(RootMenuModel* rootMenu) : QAbstractListModel(rootMenu)
{
    mRootMenu = rootMenu;
    mUid = sUID;
    ++sUID;
}


MenuEntryModel::MenuEntryModel(QString icon, QString label, QString qml, RootMenuModel* rootMenu) : QAbstractListModel(rootMenu)
{
    mRootMenu = rootMenu;
    mIcon = icon;
    mLabel = label;
    mQmlPage = qml;
    mUid = sUID;
    ++sUID;
}


//! Update selected state of menu entries
QStringList MenuEntryModel::select(int level, int index)
{
    QStringList arianePath;

    if (level == 0)
    {
        for(int idx=0; idx<mEntries.count(); idx++)
        {
            MenuEntryModel* m = qobject_cast<MenuEntryModel*>(mEntries[idx]);
            if (m != nullptr)
            {
                m->setSelected(idx == index);
                if (idx == index)
                {
                    arianePath.append(m->label());
                    mRootMenu->openMenuEntry(m);
                }
            }
        }
        mIndex = index;
    }
    else
    {
        MenuEntryModel* m = qobject_cast<MenuEntryModel*>(mEntries[mIndex]);
        m->select(level-1, index);
    }

    return arianePath;
}


void MenuEntryModel::addEntry(QObject* entry)
{
    mEntries.append(entry);
    if (mIndex == -1)
    {
        select(0,0);
    }
    emit entriesChanged();
}



int MenuEntryModel::rowCount(const QModelIndex&) const
{
    return mEntries.count();
}

QVariant MenuEntryModel::data(const QModelIndex&, int) const
{
    return "not used";
}

QHash<int, QByteArray> MenuEntryModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "label";
    return roles;
}
