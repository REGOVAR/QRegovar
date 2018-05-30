#ifndef PANELSLISTMODEL_H
#define PANELSLISTMODEL_H

#include <QtCore>
#include "Model/framework/genericproxymodel.h"
#include "panelversion.h"

class PanelsListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Name,
        Comment,
        CreationDate,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)


public:
    // Constructor
    PanelsListModel(QObject* parent=nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Load phenotype list from list of json
    Q_INVOKABLE bool loadJson(QJsonArray json);
    //! Add the provided gene to the list if not already contains
    Q_INVOKABLE bool append(PanelVersion* panel);
    //! Remove a gene from the list if possible
    Q_INVOKABLE bool remove(PanelVersion* panel);
    //! Return entry at the requested position in the list
    Q_INVOKABLE PanelVersion* getAt(int idx);
    //! Joins all the string list's strings into a single string with each element separated by the given separator (which can be an empty string).
    Q_INVOKABLE QString join(QString separator);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();


private:
    QList<PanelVersion*> mPanels;
    GenericProxyModel* mProxy = nullptr;
};

#endif // PANELSLISTMODEL_H
