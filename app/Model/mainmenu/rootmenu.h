#ifndef ROOTMENU_H
#define ROOTMENU_H

#include <QtCore>
#include "Model/subject/subject.h"
#include "Model/project/project.h"
#include "menuentry.h"



class MenuEntry;

class RootMenu: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(MenuEntry* selectedEntry READ selectedEntry NOTIFY selectedEntryChanged)

    Q_PROPERTY(int index READ index WRITE setIndex NOTIFY indexChanged)
    Q_PROPERTY(bool collapsed READ collapsed WRITE setCollapsed NOTIFY collapsedChanged)
    Q_PROPERTY(bool subLevelPanelDisplayed READ subLevelPanelDisplayed WRITE setSubLevelPanelDisplayed NOTIFY subLevelPanelDisplayedChanged)

    Q_PROPERTY(float width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(QList<QObject*> entries READ entries NOTIFY entriesChanged)


public:
    // Constructor
    RootMenu(QObject* parent=nullptr);

    // Getters
    inline MenuEntry* selectedEntry() const { return mSelectedEntry; }
    inline int index() const { return mIndex; }
    inline bool collapsed() const { return mCollapsed; }
    inline bool subLevelPanelDisplayed() const { return mSubLevelPanelDisplayed; }
    inline float width() const { return mWidth; }
    inline QList<QObject*> entries() const { return mEntries; }

    // Setters
    inline void setIndex(int index) { mIndex = index; emit indexChanged(); }
    inline void setCollapsed(bool flag) { mCollapsed = flag; emit collapsedChanged(); }
    inline void setSubLevelPanelDisplayed(bool flag) { mSubLevelPanelDisplayed = flag; mSubLevelPanelDisplayedTemp = flag; emit subLevelPanelDisplayedChanged(); }
    inline void setWidth(float w) { mWidth = w; emit widthChanged(); }

    // Methods
    Q_INVOKABLE void goTo(int lvl0, int lvl1, int lvl2);
    Q_INVOKABLE void select(int level, int index, bool notify=true);
    Q_INVOKABLE inline void hiddeSubLevelPanel() { mSubLevelPanelDisplayed = false; emit subLevelPanelDisplayedChanged(); }
    Q_INVOKABLE inline void restoreSubLevelPanel() { setSubLevelPanelDisplayed(mSubLevelPanelDisplayedTemp); }
    Q_INVOKABLE void openMenuEntry(MenuEntry* menuEntry);
    Q_INVOKABLE void openMenuEntry(Project* project);
    Q_INVOKABLE void openMenuEntry(Subject* subject);
    Q_INVOKABLE MenuEntry* getEntry(int idx);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    void initMain();
    void initFilteringAnalysis();
    void initPipelineAnalysis();

Q_SIGNALS:
    void selectedEntryChanged();
    void indexChanged();
    void collapsedChanged();
    void subLevelPanelDisplayedChanged();
    void widthChanged();
    void entriesChanged();
    void subEntriesChanged();
    void openPage(MenuEntry* menuEntry);

private:
    MenuEntry* mSelectedEntry = nullptr;
    int mIndex = -1;
    bool mCollapsed = false;
    bool mSubLevelPanelDisplayed = false;
    bool mSubLevelPanelDisplayedTemp = false;
    float mWidth = 150;
    QList<QObject*> mEntries;

    MenuEntry* mAnalysisBrowserEntry = nullptr;
    MenuEntry* mSubjectBrowserEntry = nullptr;

};

#endif // ROOTMENU_H




