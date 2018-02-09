#ifndef MENUENTRY_H
#define MENUENTRY_H


#include <QtCore>
#include "rootmenu.h"


class RootMenu;

class MenuEntry: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int uid READ uid NOTIFY neverChanged)
    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY dataChanged)
    Q_PROPERTY(QString label READ label WRITE setLabel NOTIFY dataChanged)
    Q_PROPERTY(QString qmlPage READ qmlPage WRITE setQmlPage NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> entries READ entries  NOTIFY entriesChanged)
    Q_PROPERTY(int index READ index WRITE setIndex NOTIFY indexChanged)
    Q_PROPERTY(bool selected READ selected WRITE setSelected NOTIFY selectedChanged)

    Q_PROPERTY(Project* project READ project NOTIFY neverChanged)
    Q_PROPERTY(Subject* subject READ subject NOTIFY neverChanged)

public:
    // Constructor
    MenuEntry(RootMenu* rootMenu=nullptr);
    MenuEntry(QString icon, QString label, QString qml, RootMenu* rootMenu);
    MenuEntry(QString icon, QString label, QString qml, RootMenu* rootMenu, Project* project);
    MenuEntry(QString icon, QString label, QString qml, RootMenu* rootMenu, Subject* subject);
    MenuEntry(Project* project, RootMenu* rootMenu);
    MenuEntry(Subject* subject, RootMenu* rootMenu);

    // Getters
    inline int uid() const { return mUid; }
    inline QString icon() const { return mIcon; }
    inline QString label() const { return mLabel; }
    inline QString qmlPage() const { return mQmlPage; }
    inline QList<QObject*> entries() const { return mEntries; }
    inline int index() const { return mIndex; }
    inline bool selected() const { return mSelected; }
    inline Project* project() const { return mProject; }
    inline Subject* subject() const { return mSubject; }

    // Setters
    inline void setIcon(QString icon) { mIcon=icon; emit dataChanged(); }
    inline void setLabel(QString label) { mLabel=label; emit dataChanged(); }
    inline void setQmlPage(QString qml) { mQmlPage=qml; emit dataChanged(); }
    inline void setIndex(int idx) { mIndex=idx; emit indexChanged(); }
    inline void setSelected(bool flag) { mSelected=flag; emit selectedChanged(); }

    // Methods
    Q_INVOKABLE QStringList select(int level, int index, bool notify=true);
    Q_INVOKABLE void addEntry(QObject* entry);
    Q_INVOKABLE MenuEntry* getEntry(int idx);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

Q_SIGNALS:
    void neverChanged();
    void dataChanged();
    void entriesChanged();
    void indexChanged();
    void selectedChanged();

public Q_SLOTS:
    void refresh();

protected:
    //! Icon of the menu entry (only displayed for lvl 1 & lvl 2 entries
    QString mIcon;
    //! Displayed label of the menu entry
    QString mLabel;
    //! The local path to the qml page to display for the menu entry
    QString mQmlPage;
    //! List of sub entries for this menu entry
    QList<QObject*> mEntries;
    //! Current sub entry selected (displayed)
    int mIndex = -1;
    //! True when the menu entry is selected; false otherwise.
    //! shall not be set directly by the view (updated by RootMenu.select(lvl, idx) method
    bool mSelected = false;

    Project* mProject = nullptr;
    Subject* mSubject = nullptr;

    RootMenu* mRootMenu = nullptr;

    static int sUID;
    int mUid = 0;
};

#endif // MENUENTRY_H

