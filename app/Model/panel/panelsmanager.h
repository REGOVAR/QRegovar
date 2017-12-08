#ifndef PANELSMANAGER_H
#define PANELSMANAGER_H

#include <QtCore>
#include "panel.h"
#include "panelstreemodel.h"

class PanelsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> panels READ panels NOTIFY panelsChanged)
    Q_PROPERTY(PanelsTreeModel* panelsTree READ panelsTree NOTIFY panelsChanged)
    Q_PROPERTY(Panel* newPanel READ newPanel NOTIFY newPanelChanged)


public:
    // Constructors
    explicit PanelsManager(QObject* parent=nullptr);

    // Getters
    inline QList<QObject*> panels() const { return mPanelsList; }
    inline Panel* newPanel() const { return mNewPanel; }
    inline PanelsTreeModel* panelsTree() const { return mPanelsTree; }

    // Methods
    Q_INVOKABLE Panel* getOrCreatePanel(int id);
    Q_INVOKABLE void commitNewPanel();
    Q_INVOKABLE void searchPanelEntry(QString query);
    //! refresh models with data from server
    Q_INVOKABLE void refresh();


Q_SIGNALS:
    void panelsChanged();
    void newPanelChanged();
    void commitNewPanelDone(bool success);
    void searchPanelEntryDone(QJsonObject json);

private:
    //! Internal collection of panel models
    QHash<int, Panel*> mPanels;
    //! Model for Wizard data when creating new panel
    Panel* mNewPanel = nullptr;
    //! List of all panels
    QList<QObject*> mPanelsList;
    //! Treemodel of Panels list.
    PanelsTreeModel* mPanelsTree = nullptr;

    // Methods
    //! Refresh list of panel and tree according to the internal model (called by public refresh method)
    void updatePanelsLists();
};

#endif // PANELSMANAGER_H