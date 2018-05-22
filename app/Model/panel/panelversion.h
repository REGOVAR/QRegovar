#ifndef PANELVERSION_H
#define PANELVERSION_H

#include <QtCore>
#include "Model/framework/regovarresource.h"
#include "panel.h"
#include "panelentrieslistmodel.h"

class Panel;
class PanelVersion : public RegovarResource
{
    Q_OBJECT
    // Panel attributes
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(Panel* panel READ panel NOTIFY dataChanged)
    Q_PROPERTY(int order READ order NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString fullname READ fullname NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(PanelEntriesListModel* entries READ entries NOTIFY entriesChanged)

public:
    // Constructors
    explicit PanelVersion(QObject* parent=nullptr);
    explicit PanelVersion(Panel* rootPanel, QObject* parent=nullptr);
    explicit PanelVersion(QString id, Panel* rootPanel, QObject* parent=nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline Panel* panel() const { return mPanel; }
    inline int order() const { return mOrder; }
    inline QString name() const { return mName; }
    inline QString comment() const { return mComment; }
    inline PanelEntriesListModel* entries() const { return mEntries; }
    QString fullname() const;

    // Setters
    inline void setPanel(Panel* panel) { mPanel = panel; }
    inline void setName(QString name) { mName = name; emit dataChanged(); }
    inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }

    // Override ressource methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json) override;
    //! Load panel version information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;

    // Methods
    //! Add a new entry to the list (only used by the qml wizard)
    Q_INVOKABLE void addEntry(QJsonObject data);
    //! Remove entry at the given index in the list (only used by the qml wizard)
    Q_INVOKABLE inline void removeEntryAt(int idx) { if (mEntries->rowCount() > idx) { mEntries->removeAt(idx); emit entriesChanged(); } }
    //! Remove entry at the given index in the list (only used by the qml wizard)
    Q_INVOKABLE inline void removeAllEntries() { if (mEntries->rowCount()>0) { mEntries->clear(); emit entriesChanged(); } }
    //! Reset data (only used by Creation wizard to reset its model)
    Q_INVOKABLE void reset();


Q_SIGNALS:
    void entriesChanged();

private:
    Panel* mPanel;
    QString mId;
    QString mName;
    int mOrder = 0;
    QString mComment;
    PanelEntriesListModel* mEntries;
};

#endif // PANELVERSION_H
