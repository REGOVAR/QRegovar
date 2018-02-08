#ifndef ROOTMENUMODEL_H
#define ROOTMENUMODEL_H

#include <QtCore>
#include "Model/subject/subject.h"
#include "Model/project/project.h"
#include "menuentrymodel.h"



class MenuEntryModel;

class RootMenuModel: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int selectedUid READ selectedUid NOTIFY selectedUidChanged)

    Q_PROPERTY(int index READ index WRITE setIndex NOTIFY indexChanged)
    Q_PROPERTY(bool collapsed READ collapsed WRITE setCollapsed NOTIFY collapsedChanged)
    Q_PROPERTY(bool subLevelPanelDisplayed READ subLevelPanelDisplayed WRITE setSubLevelPanelDisplayed NOTIFY subLevelPanelDisplayedChanged)

    Q_PROPERTY(float width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QList<QObject*> entries READ entries NOTIFY entriesChanged)
    Q_PROPERTY(QList<QObject*> subEntries READ subEntries NOTIFY subEntriesChanged)


public:
    // Constructor
    RootMenuModel(QObject* parent=nullptr);

    // Getters
    inline int selectedUid() const { return mSelectedUid; }
    inline int index() const { return mIndex; }
    inline bool collapsed() const { return mCollapsed; }
    inline bool subLevelPanelDisplayed() const { return mSubLevelPanelDisplayed; }
    inline float width() const { return mWidth; }
    inline QString title() const { return mTitle; }
    inline QList<QObject*> entries() const { return mEntries; }
    inline QList<QObject*> subEntries() const { return mSubEntries; }

    // Setters
    inline void setIndex(int index) { mIndex = index; emit indexChanged(); }
    inline void setCollapsed(bool flag) { mCollapsed = flag; emit collapsedChanged(); }
    inline void setSubLevelPanelDisplayed(bool flag) { mSubLevelPanelDisplayed = flag; mSubLevelPanelDisplayedTemp = flag; emit subLevelPanelDisplayedChanged(); }
    inline void setWidth(float w) { mWidth = w; emit widthChanged(); }
    inline void setTitle(QString title) { mTitle = title; emit titleChanged(); }

    // Methods
    Q_INVOKABLE QStringList select(int level, int index);
    Q_INVOKABLE inline void hiddeSubLevelPanel() { mSubLevelPanelDisplayed = false; emit subLevelPanelDisplayedChanged(); }
    Q_INVOKABLE inline void restoreSubLevelPanel() { setSubLevelPanelDisplayed(mSubLevelPanelDisplayedTemp); }
    Q_INVOKABLE void openMenuEntry(MenuEntryModel* menuEntry);
    Q_INVOKABLE void openMenuEntry(Project* project);
    Q_INVOKABLE void openMenuEntry(Subject* subject);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    void initMain();
    void initFilteringAnalysis();
    void initPipelineAnalysis();

Q_SIGNALS:
    void selectedUidChanged();
    void indexChanged();
    void collapsedChanged();
    void subLevelPanelDisplayedChanged();
    void widthChanged();
    void titleChanged();
    void entriesChanged();
    void subEntriesChanged();
    void openPage(MenuEntryModel* menuEntry);

private:
    int mSelectedUid = -1;
    int mIndex = -1;
    bool mCollapsed = false;
    bool mSubLevelPanelDisplayed = false;
    bool mSubLevelPanelDisplayedTemp = false;
    float mWidth = 150;
    QString mTitle;
    QList<QObject*> mEntries;
    QList<QObject*> mSubEntries;

};

#endif // ROOTMENUMODEL_H




