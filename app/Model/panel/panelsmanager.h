#ifndef PANELSMANAGER_H
#define PANELSMANAGER_H

#include <QtCore>
#include "panel.h"
#include "panelstreemodel.h"
#include "panelslistmodel.h"
#include "Model/framework/genericproxymodel.h"

class PanelsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PanelsListModel* panels READ panels NOTIFY panelsChanged)
    Q_PROPERTY(PanelsTreeModel* panelsTree READ panelsTree NOTIFY panelsChanged)
    Q_PROPERTY(Panel* newPanel READ newPanel NOTIFY newPanelChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)


public:
    // Constructors
    PanelsManager(QObject* parent=nullptr);

    // Getters
    inline PanelsListModel* panels() const { return mPanelsList; }
    inline Panel* newPanel() const { return mNewPanel; }
    inline PanelsTreeModel* panelsTree() const { return mPanelsTree; }
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    Q_INVOKABLE Panel* getOrCreatePanel(QString id);
    Q_INVOKABLE PanelVersion* getPanelVersion(QString id);
    Q_INVOKABLE void commitNewPanel();
    Q_INVOKABLE void searchPanelEntry(QString query);
    //! refresh models with data from server
    Q_INVOKABLE void refresh();

    bool loadJson(QJsonArray data);


Q_SIGNALS:
    void neverChanged();
    void panelsChanged();
    void newPanelChanged();
    void commitNewPanelDone(bool success);
    void searchPanelEntryDone(QJsonObject json);

private:
    //! Internal collection of panel models
    QHash<QString, Panel*> mPanels;
    //! Model for Wizard data when creating new panel
    Panel* mNewPanel = nullptr;
    //! List of all "root" panels
    PanelsListModel* mPanelsList = nullptr;
    //! Treemodel of Panels list.
    PanelsTreeModel* mPanelsTree = nullptr;
    //! The QSortFilterProxyModel to use by tree view to browse panel/version of the manager
    GenericProxyModel* mProxy = nullptr;
};

#endif // PANELSMANAGER_H
