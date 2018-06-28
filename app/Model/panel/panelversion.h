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
    PanelVersion(Panel* rootPanel=nullptr);
    PanelVersion(Panel* rootPanel, QJsonObject json);

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
    inline void setOrder(int order) { mOrder = order; }  // no need to emit dataChanged

    // Override ressource methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(const QJsonObject& json, bool full_init=true) override;
    //! Load panel version information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Save model information onto server
    Q_INVOKABLE void save() override;

    // Methods
    //! Add a new entry to the list (only used by the qml wizard)
    Q_INVOKABLE void addEntry(QJsonObject data);
    //! Remove entry at the given index in the list (only used by the qml wizard)
    Q_INVOKABLE inline void removeEntryAt(int idx) { if (mEntries->rowCount() > idx) { mEntries->removeAt(idx); emit entriesChanged(); } }
    //! Remove entry at the given index in the list (only used by the qml wizard)
    Q_INVOKABLE inline void removeAllEntries() { if (mEntries->rowCount()>0) { mEntries->clear(); emit entriesChanged(); } }
    //! Reset data (only used by Creation wizard to reset its model)
    Q_INVOKABLE void reset(Panel* panel=nullptr);


Q_SIGNALS:
    void entriesChanged();


public Q_SLOTS:
    void updateSearchField() override;
    void emitEntriesChanged();

private:
    Panel* mPanel = nullptr;
    QString mId;
    QString mName;
    int mOrder = 0;
    QString mComment;
    PanelEntriesListModel* mEntries = nullptr;
};

#endif // PANELVERSION_H
