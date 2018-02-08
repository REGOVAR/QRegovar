#ifndef MENUENTRYMODEL_H
#define MENUENTRYMODEL_H


#include <QtCore>
#include "rootmenumodel.h"

class RootMenuModel;




class MenuEntryModel: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int uid READ uid NOTIFY uidChanged)
    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY dataChanged)
    Q_PROPERTY(QString label READ label WRITE setLabel NOTIFY dataChanged)
    Q_PROPERTY(QString qmlPage READ qmlPage WRITE setQmlPage NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> entries READ entries  NOTIFY entriesChanged)
    Q_PROPERTY(int index READ index WRITE setIndex NOTIFY indexChanged)
    Q_PROPERTY(bool selected READ selected WRITE setSelected NOTIFY selectedChanged)

public:


    // Constructor
    MenuEntryModel(RootMenuModel* rootMenu=nullptr);
    MenuEntryModel(QString icon, QString label, QString qml, RootMenuModel* rootMenu=nullptr);

    // Getters
    inline int uid() const { return mUid; }
    inline QString icon() const { return mIcon; }
    inline QString label() const { return mLabel; }
    inline QString qmlPage() const { return mQmlPage; }
    inline QList<QObject*> entries() const { return mEntries; }
    inline int index() const { return mIndex; }
    inline bool selected() const { return mSelected; }

    // Setters
    inline void setIcon(QString icon) { mIcon=icon; emit dataChanged(); }
    inline void setLabel(QString label) { mLabel=label; emit dataChanged(); }
    inline void setQmlPage(QString qml) { mQmlPage=qml; emit dataChanged(); }
    inline void setIndex(int idx) { mIndex=idx; emit indexChanged(); }
    inline void setSelected(bool flag) { mSelected=flag; emit selectedChanged(); }

    // Methods
    Q_INVOKABLE QStringList select(int level, int index);
    Q_INVOKABLE void addEntry(QObject* entry);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

Q_SIGNALS:
    void uidChanged();
    void dataChanged();
    void entriesChanged();
    void indexChanged();
    void selectedChanged();

private:
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
    //! shall not be set directly by the view (updated by RootMenuModel.select(lvl, idx) method
    bool mSelected = false;

    RootMenuModel* mRootMenu;

    static int sUID;
    int mUid = 0;
};

#endif // MENUENTRYMODEL_H

