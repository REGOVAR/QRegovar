#ifndef PANELVERSIONSLISTMODEL_H
#define PANELVERSIONSLISTMODEL_H

#include <QtCore>
#include "Model/framework/genericproxymodel.h"
#include "panelversion.h"

class PanelVersionsListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Order,
        Name,
        Comment,
        CreationDate,
        UpdateDate,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)


public:
    // Constructor
    explicit PanelVersionsListModel(QObject* parent=nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Load panel versions list from json
    Q_INVOKABLE bool loadJson(QJsonArray json);
    //! Add the provided panel version to the list if not already contains
    Q_INVOKABLE bool append(PanelVersion* version);
    //! Remove a panel version from the list if possible
    Q_INVOKABLE bool remove(PanelVersion* version);
    //! Remove version at the requested position in the list
    Q_INVOKABLE bool removeAt(int idx);
    //! Return version at the requested position in the list
    Q_INVOKABLE PanelVersion* getAt(int idx);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    // Methods
    //! Add a new version to the panel (append=true should be only used by factory)
    Q_INVOKABLE bool addVersion(QJsonObject data, bool append=false);
    Q_INVOKABLE bool addVersion(PanelVersion* version);
    //! Return panel version details if provided id match; otherwise return null
    Q_INVOKABLE inline PanelVersion* getVersion(QString versionId) const { return mVersionsMap.contains(versionId) ? mVersionsMap.value(versionId): nullptr; }
    Q_INVOKABLE PanelVersion* const headVersion();

Q_SIGNALS:
    void neverChanged();
    void countChanged();


private:
    QList<PanelVersion*> mPanelVersionsList;
    GenericProxyModel* mProxy = nullptr;

    // Internal attributes
    QHash<QString, PanelVersion*> mVersionsMap;
};

#endif // PANELVERSIONSLISTMODEL_H
