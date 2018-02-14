#include "menuentry.h"

int MenuEntry::sUID = 0;

MenuEntry::MenuEntry(RootMenu* rootMenu) : QAbstractListModel(rootMenu)
{
    mRootMenu = rootMenu;
    mUid = sUID;
    ++sUID;
}


MenuEntry::MenuEntry(QString icon, QString label, QString qml, RootMenu* rootMenu) : MenuEntry(rootMenu)
{
    mIcon = icon;
    mLabel = label;
    mQmlPage = qml;
}

MenuEntry::MenuEntry(QString icon, QString label, QString qml, RootMenu* rootMenu, Project* project): MenuEntry(icon, label, qml, rootMenu)
{
    mProject = project;
}
MenuEntry::MenuEntry(QString icon, QString label, QString qml, RootMenu* rootMenu, Subject* subject): MenuEntry(icon, label, qml, rootMenu)
{
    mSubject = subject;
}
MenuEntry::MenuEntry(Project* project, RootMenu* rootMenu): MenuEntry(rootMenu)
{
    mProject = project;
    mQmlPage = "";
    mIcon = "6";
    connect(project, &Project::dataChanged, this, &MenuEntry::refresh);

    // Create lvl3 menu entries
    mEntries.append(new MenuEntry("a", tr("Summary"), "Project/SummaryPage.qml", mRootMenu, project));
    mEntries.append(new MenuEntry("^", tr("Analyses"), "Project/AnalysesPage.qml", mRootMenu, project));
    mEntries.append(new MenuEntry("3", tr("Subjects"), "Project/SubjectsPage.qml", mRootMenu, project));
    //mEntries.append(new MenuEntry("n", tr("Files"), "Project/FilesPage.qml", mRootMenu, project));
    select(0,0, false);

    refresh();
}
MenuEntry::MenuEntry(Subject* subject, RootMenu* rootMenu): MenuEntry(rootMenu)
{
    mSubject = subject;
    mQmlPage = "";
    mIcon = subject->sex() == Subject::Sex::Male ? "9" : subject->sex() == Subject::Sex::Female ? "9" : "b";
    connect(subject, &Subject::dataChanged, this, &MenuEntry::refresh);


    // Create lvl3 menu entries
    mEntries.append(new MenuEntry("", tr("Summary"), "Subject/SummaryPage.qml", mRootMenu, subject));
    mEntries.append(new MenuEntry("", tr("Phenotype"), "Subject/PhenotypesPage.qml", mRootMenu, subject));
    mEntries.append(new MenuEntry("", tr("Samples"), "Subject/SamplesPage.qml", mRootMenu, subject));
    mEntries.append(new MenuEntry("", tr("Analyses"), "Subject/AnalysesPage.qml", mRootMenu, subject));
    mEntries.append(new MenuEntry("", tr("Files"), "Subject/FilesPage.qml", mRootMenu, subject));
    select(0,0, false);

    refresh();
}


//! Update selected state of menu entries
QStringList MenuEntry::select(int level, int index, bool notify)
{
    QStringList arianePath;

    if (level == 0)
    {
        MenuEntry* toOpen;
        for(int idx=0; idx<mEntries.count(); idx++)
        {
            MenuEntry* m = qobject_cast<MenuEntry*>(mEntries[idx]);
            if (m != nullptr)
            {
                m->setSelected(idx == index);
                if (idx == index)
                {
                    arianePath.append(m->label());
                    toOpen = m; // don't open now, need to update all menu entrie first
                }
            }
        }
        mIndex = index;
        if (notify) mRootMenu->openMenuEntry(toOpen);
    }
    else
    {
        MenuEntry* m = qobject_cast<MenuEntry*>(mEntries[mIndex]);
        m->select(level-1, index, notify);
    }

    return arianePath;
}


void MenuEntry::addEntry(QObject* entry)
{
    mEntries.append(entry);
    if (mIndex == -1)
    {
        select(0,0, false);
    }
}

MenuEntry* MenuEntry::getEntry(int idx)
{
    MenuEntry* result = nullptr;
    if (idx >= 0 && idx < mEntries.count()) result = qobject_cast<MenuEntry*>(mEntries[idx]);
    return result;
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




void MenuEntry::refresh()
{
    if (mProject != nullptr) setLabel(mProject->name());
    if (mSubject != nullptr)
    {
        setIcon(mSubject->sex() == Subject::Sex::Male ? "9" : mSubject->sex() == Subject::Sex::Female ? "9" : "b");
        setLabel(mSubject->firstname() + " " + mSubject->lastname());
    }
}
