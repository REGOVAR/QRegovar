#ifndef SUBJECTSLISTMODEL_H
#define SUBJECTSLISTMODEL_H

#include <QtCore>
#include "Model/framework/genericproxymodel.h"

class Subject;
class SubjectsListModel: public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Identifier,
        Firstname,
        Lastname,
        Comment,
        Sex,
        DateOfBirth,
        FamilyNumber,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    SubjectsListModel(QObject* parent = nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    //! Remove all entries of the list
    Q_INVOKABLE void clear();
    //! Clear list and load entries from json data
    Q_INVOKABLE bool loadJson(QJsonArray json);
    //! Add the provided subject to the list if not already contains
    Q_INVOKABLE bool append(Subject* subject);
    //! Remove a subject from the list if possible
    Q_INVOKABLE bool remove(Subject* subject);
    //! Return entry at the requested position; nullptr if not exists
    Q_INVOKABLE Subject* getAt(int idx);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

Q_SIGNALS:
    void neverChanged();
    void countChanged();

private:
    //! List of subjects
    QList<Subject*> mSubjects;
    //! The QSortFilterProxyModel to use by table view to browse subject of the manager
    GenericProxyModel* mProxy = nullptr;
};

#endif // SUBJECTSLISTMODEL_H
