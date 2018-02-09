#ifndef SUBJECTMENUENTRY_H
#define SUBJECTMENUENTRY_H

#include "menuentry.h"

class SubjectMenuEntry: public MenuEntry
{
    Q_OBJECT
    Q_PROPERTY(Subject* subject READ subject NOTIFY subjectChanged)

public:
    // Constructor
    SubjectMenuEntry(RootMenu* rootMenu=nullptr);
    SubjectMenuEntry(Subject* subject, RootMenu* rootMenu=nullptr);

    // Getter
    inline Subject* subject() const { return mSubject; }

Q_SIGNALS:
    void subjectChanged();

public Q_SLOTS:
    void refresh();

private:
    Subject* mSubject;
};

#endif // SUBJECTMENUENTRY_H
