#ifndef JSONLISTMODEL_H
#define JSONLISTMODEL_H

#include <QtCore>
#include "Model/framework/genericproxymodel.h"

class JsonListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Json,
        // Adding some usual key found in almost all regovar json object
        Name, // Label, Symbol,
        Comment, // Description, Details,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)


public:
    // Constructor
    JsonListModel(QObject* parent=nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Load phenotype list from list of json
    Q_INVOKABLE bool loadJson(const QJsonArray& json);
    //! Add the provided gene to the list if not already contains
    Q_INVOKABLE bool append(const QJsonObject& json);
    //! Remove a gene from the list if possible
    Q_INVOKABLE bool remove(const QJsonObject& json);
    //! Return entry at the requested position in the list
    Q_INVOKABLE QJsonObject getAt(int idx);
    //! Joins all the string list's strings into a single string with each element separated by the given separator (which can be an empty string).
    Q_INVOKABLE QString join(QString separator, QString key="name");

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


Q_SIGNALS:
    void neverChanged();
    void countChanged();


private:
    QList<QJsonObject> mJson;
    GenericProxyModel* mProxy = nullptr;
};

#endif // JSONLISTMODEL_H
