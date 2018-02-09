#include "subjectmenuentry.h"


SubjectMenuEntry::SubjectMenuEntry(RootMenu* rootMenu): MenuEntry(rootMenu)
{

}
SubjectMenuEntry::SubjectMenuEntry(Subject* subject, RootMenu* rootMenu): MenuEntry(rootMenu)
{
    mSubject = subject;
    mIcon = "b";
    connect(subject, Subject::dataChanged, this, SubjectMenuEntry::refresh);

    // Create lvl3 menu entries
    mEntries.append(new MenuEntry("", tr("Summary"), "Subject/SummaryPage.qml", mRootMenu));
    mEntries.append(new MenuEntry("", tr("Phenotype"), "Subject/PhenotypesPage.qml", mRootMenu));
    mEntries.append(new MenuEntry("", tr("Samples"), "Subject/SamplesPage.qml", mRootMenu));
    mEntries.append(new MenuEntry("", tr("Analyses"), "Subject/AnalysesPage.qml", mRootMenu));
    mEntries.append(new MenuEntry("", tr("Files"), "Subject/FilesPage.qml", mRootMenu));
    select(0,0);

    refresh();
}

void SubjectMenuEntry::refresh()
{
    setLabel(mSubject->firstname() + " " + mSubject->lastname());
}
