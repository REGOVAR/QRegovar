#ifndef PANEL_H
#define PANEL_H

#include <QtCore>
#include "Model/framework/genericproxymodel.h"
#include "panelversionslistmodel.h"
#include "panelversion.h"

class Panel : public RegovarResource
{
    Q_OBJECT
    // Panel attributes
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY dataChanged)
    Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY dataChanged)
    Q_PROPERTY(bool shared READ shared WRITE setShared NOTIFY dataChanged)
    Q_PROPERTY(PanelVersionsListModel* versions READ versions NOTIFY dataChanged)
    Q_PROPERTY(PanelVersion* headVersion READ headVersion NOTIFY dataChanged)


public:
    // Constructors
    explicit Panel(QObject* parent=nullptr);
    explicit Panel(QJsonObject json, QObject* parent=nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString name() const { return mName; }
    inline QString description() const { return mDescription; }
    inline QString owner() const { return mOwner; }
    inline bool shared() const { return mShared; }
    inline PanelVersionsListModel* versions() const { return mVersions; }
    inline PanelVersion* headVersion() { return mVersions->headVersion(); }
    // Setters
    inline void setName(QString name) { mName = name; emit dataChanged(); }
    inline void setDescription(QString desc) { mDescription = desc; emit dataChanged(); }
    inline void setOwner(QString owner) { mOwner = owner; emit dataChanged(); }
    inline void setShared(bool flag) { mShared = flag; emit dataChanged(); }

    // Override ressource methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Save panel information onto server
    Q_INVOKABLE void save() override;
    //! Load panel information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;

    // New/Edit Panel Wizard dedicated methods
    //! Reset the model with same information as provided panel version
    Q_INVOKABLE void reset(Panel* panel=nullptr);
    //! Save the panel + head version onto server
    Q_INVOKABLE void saveNewVersion();
    //! Add new entry to the current new panel/version
    Q_INVOKABLE void addEntry(QJsonObject json);



Q_SIGNALS:
    void neverChanged();
    void dataChanged();
    void entriesChanged();


public Q_SLOTS:
    void updateSearchField();


private:
    QString mId;
    QString mName;
    QString mDescription;
    QString mOwner;
    bool mShared = false;
    PanelVersionsListModel* mVersions = nullptr;

};

#endif // PANEL_H
