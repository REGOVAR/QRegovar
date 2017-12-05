#ifndef PANELSMANAGER_H
#define PANELSMANAGER_H

#include <QtCore>
#include "panel.h"

class PanelsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> panels READ panels NOTIFY panelsChanged)
    Q_PROPERTY(Panel* newPanel READ newPanel NOTIFY newPanelChanged)


public:
    // Constructors
    explicit PanelsManager(QObject* parent=nullptr);

    // Getters
    inline QList<QObject*> panels() const { return mPanelsList; }
    inline Panel* newPanel() const { return mNewPanel; }

    // Methods
    Q_INVOKABLE Panel* getOrCreatePanel(int id);
    Q_INVOKABLE void commitNewPanel();
    Q_INVOKABLE void searchPanelEntry(QString query);

    void updatePanelsList();

Q_SIGNALS:
    void panelsChanged();
    void newPanelChanged();
    void commitNewPanelDone(bool success);
    void searchPanelEntryDone(QJsonObject json);

private:
    //! Internal collection of panel models
    QHash<int, Panel*> mPanels;
    //! List of all panels
    QList<QObject*> mPanelsList;
    //! Model for Wizard data when creating new panel
    Panel* mNewPanel = nullptr;

};

#endif // PANELSMANAGER_H
