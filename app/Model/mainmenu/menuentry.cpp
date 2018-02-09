#include "menuentry.h"

int MenuEntry::sUID = 0;

MenuEntry::MenuEntry(RootMenu* rootMenu) : QAbstractListModel(rootMenu)
{
    mRootMenu = rootMenu;
    mUid = sUID;
    ++sUID;
}


MenuEntry::MenuEntry(QString icon, QString label, QString qml, RootMenu* rootMenu) : QAbstractListModel(rootMenu)
{
    mRootMenu = rootMenu;
    mIcon = icon;
    mLabel = label;
    mQmlPage = qml;
    mUid = sUID;
    ++sUID;
}


//! Update selected state of menu entries
QStringList MenuEntry::select(int level, int index)
{
    QStringList arianePath;

    if (level == 0)
    {
        for(int idx=0; idx<mEntries.count(); idx++)
        {
            MenuEntry* m = qobject_cast<MenuEntry*>(mEntries[idx]);
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
        MenuEntry* m = qobject_cast<MenuEntry*>(mEntries[mIndex]);
        m->select(level-1, index);
    }

    return arianePath;
}


void MenuEntry::addEntry(QObject* entry)
{
    mEntries.append(entry);
    if (mIndex == -1)
    {
        select(0,0);
    }
    emit entriesChanged();
    emit mRootMenu->subEntriesChanged();
}



int MenuEntry::rowCount(const QModelIndex&) const
{
    return mEntries.count();
}

QVariant MenuEntry::data(const QModelIndex&, int) const
{
    return "not used";
}

QHash<int, QByteArray> MenuEntry::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "label";
    return roles;
}
