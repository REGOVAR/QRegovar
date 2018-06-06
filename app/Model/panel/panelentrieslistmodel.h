#ifndef PANELENTRIESLISTMODEL_H
#define PANELENTRIESLISTMODEL_H

#include <QtCore>
#include "Model/framework/genericproxymodel.h"
#include "panelentry.h"

class PanelEntriesListModel: public QAbstractListModel
{
    enum Roles
    {
        Label = Qt::UserRole + 1,
        Type,
        Details,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructor
    PanelEntriesListModel(QObject* parent=nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Load panel entries list from json
    Q_INVOKABLE bool loadJson(QJsonArray json);
    //! Add the provided panel entry to the list if not already contains
    Q_INVOKABLE bool append(PanelEntry* entry);
    //! Remove a panel entry from the list if possible
    Q_INVOKABLE bool remove(PanelEntry* entry);
    //! Remove entry at the requested position in the list
    Q_INVOKABLE bool removeAt(int idx);
    //! Return entry at the requested position in the list
    Q_INVOKABLE PanelEntry* getAt(int idx);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();


private:
    QList<PanelEntry*> mPanelEntriesList;
    GenericProxyModel* mProxy = nullptr;
};

#endif // PANELENTRIESLISTMODEL_H
