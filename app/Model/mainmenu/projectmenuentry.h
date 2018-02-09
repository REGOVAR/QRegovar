#ifndef PROJECTMENUENTRY_H
#define PROJECTMENUENTRY_H

#include "menuentry.h"

class ProjectMenuEntry: public MenuEntry
{
    Q_OBJECT
    Q_PROPERTY(Project* project READ project NOTIFY projectChanged)

public:
    // Constructor
    ProjectMenuEntry(RootMenu* rootMenu=nullptr);
    ProjectMenuEntry(Project* project, RootMenu* rootMenu=nullptr);

    // Getter
    inline Project* project() const { return mProject; }

Q_SIGNALS:
    void projectChanged();

public Q_SLOTS:
    void refresh();

private:
    Project* mProject;
};

#endif // PROJECTMENUENTRY_H
