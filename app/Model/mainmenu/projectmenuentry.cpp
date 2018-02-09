#include "projectmenuentry.h"



ProjectMenuEntry::ProjectMenuEntry(RootMenu* rootMenu): MenuEntry(rootMenu)
{

}
ProjectMenuEntry::ProjectMenuEntry(Project* project, RootMenu* rootMenu): MenuEntry(rootMenu)
{
    mProject = project;
    mIcon = "6";
    connect(project, Project::dataChanged, this, ProjectMenuEntry::refresh);

    // Create lvl3 menu entries
    mEntries.append(new MenuEntry("a", tr("Summary"), "Project/SummaryPage.qml", mRootMenu));
    mEntries.append(new MenuEntry("^", tr("Analyses"), "Project/AnalysesPage.qml", mRootMenu));
    mEntries.append(new MenuEntry("3", tr("Subjects"), "Project/SubjectsPage.qml", mRootMenu));
    //mEntries.append(new MenuEntry("n", tr("Files"), "Project/FilesPage.qml", mRootMenu));
    select(0,0);

    refresh();
}

void ProjectMenuEntry::refresh()
{
    setLabel(mProject->name());
}
