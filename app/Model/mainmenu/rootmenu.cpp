#include "rootmenu.h"


RootMenu::RootMenu(QObject* parent): QAbstractListModel(parent)
{
}



void RootMenu::initMain()
{
    // Create lvl3 menu entries
    MenuEntry* applicationEntry = new MenuEntry("I", tr("Application"), "", this);
    applicationEntry->addEntry(new MenuEntry("", tr("Regovar"), "Settings/ApplicationRegovarPage.qml", this));
    applicationEntry->addEntry(new MenuEntry("", tr("Interface"), "Settings/ApplicationInterfacePage.qml", this));
    applicationEntry->addEntry(new MenuEntry("", tr("Connection"), "Settings/ApplicationConnectionPage.qml", this));
    applicationEntry->addEntry(new MenuEntry("", tr("Cache"), "Settings/ApplicationCachePage.qml", this));
    MenuEntry* administrationEntry = new MenuEntry("d", tr("Administration"), "", this);
    administrationEntry->addEntry(new MenuEntry("", tr("Server"), "Settings/AdminServerPage.qml", this));
    administrationEntry->addEntry(new MenuEntry("", tr("Users"), "Settings/AdminUsersPage.qml", this));
    administrationEntry->addEntry(new MenuEntry("", tr("Pipelines"), "Settings/AdminPipesPage.qml", this));
    administrationEntry->addEntry(new MenuEntry("", tr("Annotations"), "Settings/AdminAnnotationsPage.qml", this));

    // Create lvl2 menu entries
    mProjectBrowserEntry = new MenuEntry("c", tr("Projects"), "", this);
    mProjectBrowserEntry->addEntry(new MenuEntry("c", tr("Browser"), "Browse/ProjectsPage.qml", this));
    mSubjectBrowserEntry = new MenuEntry("b", tr("Subjects"), "", this);
    mSubjectBrowserEntry->addEntry(new MenuEntry("z", tr("Browser"), "Browse/SubjectsPage.qml", this));
    MenuEntry* settingsEntry = new MenuEntry("d", tr("Settings"), "", this);
    settingsEntry->addEntry(new MenuEntry("b", tr("My profile"), "Settings/ProfilePage.qml", this));
    settingsEntry->addEntry(applicationEntry);
    settingsEntry->addEntry(new MenuEntry("^", tr("Statistics"), "Settings/StatisticsPage.qml", this));
    settingsEntry->addEntry(administrationEntry);
    MenuEntry* helpEntry = new MenuEntry("e", tr("Help"), "", this);
    helpEntry->addEntry(new MenuEntry("e", tr("User guide"), "Help/UserGuidePage.qml", this));
    helpEntry->addEntry(new MenuEntry("e", tr("About"), "Help/AboutPage.qml", this));

    // Create lvl1 menu entries
    mEntries.append(new MenuEntry("a", tr("Welcome"), "WelcomPage.qml", this));
    mEntries.append(new MenuEntry("z", tr("Search"), "Browse/SearchPage.qml", this));
    mEntries.append(mProjectBrowserEntry);
    mEntries.append(mSubjectBrowserEntry);
    mEntries.append(new MenuEntry("q", tr("Panels"), "Panel/PanelsPage.qml", this));
    mEntries.append(settingsEntry);
    mEntries.append(helpEntry);

    select(0,0);
}
void RootMenu::initFilteringAnalysis()
{
    // Create lvl1 menu entries
    mEntries.append(new MenuEntry("a", tr("Analysis"), "Analysis/Filtering/SummaryPage.qml", this));
    mEntries.append(new MenuEntry("^", tr("Statistics"), "Analysis/Filtering/StatisticsPage.qml", this));
    mEntries.append(new MenuEntry("3", tr("Filtering"), "Analysis/Filtering/FilteringPage.qml", this));
    mEntries.append(new MenuEntry("n", tr("Result"), "Analysis/Filtering/ResultPage.qml", this));
    mEntries.append(new MenuEntry("e", tr("Help"), "Analysis/Filtering/HelpPage.qml", this));
    mEntries.append(new MenuEntry("h", tr("Close"), "@close", this));
    select(0,0);
}
void RootMenu::initPipelineAnalysis()
{

}


QStringList RootMenu::select(int lvl0, int lvl1, int lvl2)
{
    MenuEntry* entry = nullptr;
    if (lvl0 >= 0 && lvl0 < mEntries.count())
    {
        select(0, lvl0, false);
        entry = getEntry(lvl0);
        if (lvl1 >= 0 && lvl1 < entry->rowCount())
        {
            entry->select(0, lvl1, false);
            entry = entry->getEntry(lvl1);
            if (lvl2 >= 0 && lvl2 < entry->rowCount())
            {
                entry->select(0, lvl2, false);
                entry = entry->getEntry(lvl2);
            }
        }
    }
    openMenuEntry(entry);
}

//! Update selected state of menu entries
QStringList RootMenu::select(int level, int index, bool notify)
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
                    setSubLevelPanelDisplayed(m->entries().count() > 0);
                    toOpen = m; // don't open now, need to update all menu model first
                }
            }
        }
        mIndex = index;
        if (notify) openMenuEntry(toOpen);
        emit subEntriesChanged();
    }
    else
    {
        MenuEntry* m = qobject_cast<MenuEntry*>(mEntries[mIndex]);
        m->select(level-1, index, notify);
        setSubLevelPanelDisplayed(true);
    }

    return arianePath;
}



void RootMenu::openMenuEntry(MenuEntry* menuEntry)
{
    if (menuEntry->qmlPage().isEmpty() && menuEntry->entries().count() > 0)
    {
        openMenuEntry(qobject_cast<MenuEntry*>(menuEntry->entries()[menuEntry->index()]));
    }
    else
    {
        mSelectedEntry = menuEntry;
        emit openPage(menuEntry);
    }
}
void RootMenu::openMenuEntry(Project* project)
{
    if (mProjectBrowserEntry != nullptr && project != nullptr)
    {
        // Try to retrieve the menu entry corresponding to this project (maybe already exists)
        MenuEntry* entry = nullptr;
        for (QObject* o: mProjectBrowserEntry->entries())
        {
            MenuEntry* pm = qobject_cast<MenuEntry*>(o);
            if (pm != nullptr && pm->project() == project)
            {
                entry = pm;
                break;
            }
        }
        // Create it if not exists
        if (entry == nullptr)
        {
            entry = new MenuEntry(project, this);
            mProjectBrowserEntry->addEntry(entry);
            mProjectBrowserEntry->entries().move(mProjectBrowserEntry->entries().count()-1, 1);
        }
        // /!\ the selected entry of the menu is the selected sub entries, not the entry tiself
        mSelectedEntry = entry->getEntry(entry->index());
        mProjectBrowserEntry->select(0, mProjectBrowserEntry->entries().indexOf(entry));
        emit openPage(mSelectedEntry);
    }
}
void RootMenu::openMenuEntry(Subject* subject)
{
    if (mSubjectBrowserEntry != nullptr && subject != nullptr)
    {
        // Try to retrieve the menu entry corresponding to this subject (maybe already exists)
        MenuEntry* entry = nullptr;
        for (QObject* o: mSubjectBrowserEntry->entries())
        {
            MenuEntry* pm = qobject_cast<MenuEntry*>(o);
            if (pm != nullptr && pm->subject() == subject)
            {
                entry = pm;
                break;
            }
        }
        // Create it if not exists
        if (entry == nullptr)
        {
            entry = new MenuEntry(subject, this);
            mSubjectBrowserEntry->addEntry(entry);
            mSubjectBrowserEntry->entries().move(mSubjectBrowserEntry->entries().count()-1, 1);
        }
        mSelectedEntry = entry->getEntry(entry->index());
        mSubjectBrowserEntry->select(0, mSubjectBrowserEntry->entries().indexOf(entry));
        emit openPage(mSelectedEntry);
    }
}


MenuEntry* RootMenu::getEntry(int idx)
{
    MenuEntry* result = nullptr;
    if (idx >= 0 && idx < mEntries.count()) result = qobject_cast<MenuEntry*>(mEntries[idx]);
    return result;
}

int RootMenu::rowCount(const QModelIndex&) const
{
    return mEntries.count();
}

QVariant RootMenu::data(const QModelIndex&, int) const
{
    return "not used";
}

QHash<int, QByteArray> RootMenu::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "label";
    return roles;
}
