#include "rootmenumodel.h"

RootMenuModel::RootMenuModel(QObject* parent): QAbstractListModel(parent)
{
}



void RootMenuModel::initMain()
{
    // Create lvl3 menu entries
    MenuEntryModel* applicationEntry = new MenuEntryModel("I", tr("Application"), "", this);
    applicationEntry->addEntry(new MenuEntryModel("", tr("Regovar"), "Settings/ApplicationRegovarPage.qml", this));
    applicationEntry->addEntry(new MenuEntryModel("", tr("Interface"), "Settings/ApplicationInterfacePage.qml", this));
    applicationEntry->addEntry(new MenuEntryModel("", tr("Connection"), "Settings/ApplicationConnectionPage.qml", this));
    applicationEntry->addEntry(new MenuEntryModel("", tr("Cache"), "Settings/ApplicationCachePage.qml", this));
    MenuEntryModel* administrationEntry = new MenuEntryModel("d", tr("Administration"), "", this);
    administrationEntry->addEntry(new MenuEntryModel("", tr("Server"), "Settings/AdminServerPage.qml", this));
    administrationEntry->addEntry(new MenuEntryModel("", tr("Users"), "Settings/AdminUsersPage.qml", this));
    administrationEntry->addEntry(new MenuEntryModel("", tr("Pipelines"), "Settings/AdminPipesPage.qml", this));
    administrationEntry->addEntry(new MenuEntryModel("", tr("Annotations"), "Settings/AdminAnnotationsPage.qml", this));

    // Create lvl2 menu entries
    MenuEntryModel* projectEntry = new MenuEntryModel("c", tr("Projects"), "", this);
    projectEntry->addEntry(new MenuEntryModel("c", tr("Browser"), "Browse/ProjectsPage.qml", this));
    MenuEntryModel* subjectEntry = new MenuEntryModel("b", tr("Subjects"), "", this);
    subjectEntry->addEntry(new MenuEntryModel("z", tr("Browser"), "Browse/SubjectsPage.qml", this));
    MenuEntryModel* settingsEntry = new MenuEntryModel("d", tr("Settings"), "", this);
    settingsEntry->addEntry(new MenuEntryModel("b", tr("My profile"), "Settings/ProfilePage.qml", this));
    settingsEntry->addEntry(applicationEntry);
    settingsEntry->addEntry(new MenuEntryModel("^", tr("Statistics"), "Settings/StatisticsPage.qml", this));
    settingsEntry->addEntry(administrationEntry);
    MenuEntryModel* helpEntry = new MenuEntryModel("e", tr("Help"), "", this);
    helpEntry->addEntry(new MenuEntryModel("e", tr("User guide"), "Help/UserGuidePage.qml", this));
    helpEntry->addEntry(new MenuEntryModel("e", tr("About"), "Help/AboutPage.qml", this));

    // Create lvl1 menu entries
    mEntries.append(new MenuEntryModel("a", tr("Welcome"), "WelcomPage.qml", this));
    mEntries.append(new MenuEntryModel("z", tr("Search"), "Browse/SearchPage.qml", this));
    mEntries.append(projectEntry);
    mEntries.append(subjectEntry);
    mEntries.append(new MenuEntryModel("q", tr("Panels"), "Panel/PanelsPage.qml", this));
    mEntries.append(settingsEntry);
    mEntries.append(helpEntry);

    select(0,0);
}
void RootMenuModel::initFilteringAnalysis()
{
    // Create lvl1 menu entries
    mEntries.append(new MenuEntryModel("a", tr("Analysis"), "Analysis/Filtering/SummaryPage.qml", this));
    mEntries.append(new MenuEntryModel("^", tr("Statistics"), "Analysis/Filtering/StatisticsPage.qml", this));
    mEntries.append(new MenuEntryModel("3", tr("Filtering"), "Analysis/Filtering/FilteringPage.qml", this));
    mEntries.append(new MenuEntryModel("n", tr("Result"), "Analysis/Filtering/ResultPage.qml", this));
    mEntries.append(new MenuEntryModel("e", tr("Help"), "Analysis/Filtering/HelpPage.qml", this));
    mEntries.append(new MenuEntryModel("h", tr("Close"), "@close", this));
    select(0,0);
}
void RootMenuModel::initPipelineAnalysis()
{

}


//! Update selected state of menu entries
QStringList RootMenuModel::select(int level, int index)
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
                    setSubLevelPanelDisplayed(m->entries().count() > 0);
                    mSubEntries = m->entries();
                    emit subEntriesChanged();
                    openMenuEntry(m);
                }
            }
        }
        mIndex = index;
    }
    else
    {
        MenuEntryModel* m = qobject_cast<MenuEntryModel*>(mEntries[mIndex]);
        m->select(level-1, index);
        setSubLevelPanelDisplayed(true);
    }

    return arianePath;
}


void RootMenuModel::openMenuEntry(MenuEntryModel* menuEntry)
{
    if (menuEntry->qmlPage().isEmpty() && menuEntry->entries().count() > 0)
    {
        openMenuEntry(qobject_cast<MenuEntryModel*>(menuEntry->entries()[menuEntry->index()]));
    }
    else
    {
        mSelectedUid = menuEntry->uid();
        emit openPage(menuEntry);
    }
}
void RootMenuModel::openMenuEntry(Project* project)
{

}
void RootMenuModel::openMenuEntry(Subject* subject)
{

}



int RootMenuModel::rowCount(const QModelIndex&) const
{
    return mEntries.count();
}

QVariant RootMenuModel::data(const QModelIndex&, int) const
{
    return "not used";
}

QHash<int, QByteArray> RootMenuModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "label";
    return roles;
}
