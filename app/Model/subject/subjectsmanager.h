#ifndef SUBJECTSMANAGER_H
#define SUBJECTSMANAGER_H

#include <QtCore>
#include "subject.h"
#include "Model/framework/genericproxymodel.h"

class SubjectsManager : public QAbstractListModel
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
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructor
    explicit SubjectsManager(QObject* parent = nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }


    // Methods
    Q_INVOKABLE Subject* getOrCreateSubject(int id);
    Q_INVOKABLE void newSubject(QString identifier, QString firstname, QString lastname, int sex, QString dateOfBirth, QString familyNumber, QString comment);
    Q_INVOKABLE void openSubject(int id);
    //! refresh models with data from server
    Q_INVOKABLE void refresh();
    bool loadJson(QJsonArray json);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

Q_SIGNALS:
    void neverChanged();
    // Property changed event
    void searchQueryChanged();
    //! Event on subject creation done (sync with server done)
    void subjectCreationDone(bool success, int subjectId);

private:
    //! List of subjects
    QHash<int, Subject*> mSubjects;
    //! Query use to search subjects in the browser
    QString mSearchQuery;
    //! The QSortFilterProxyModel to use by table view to browse subject of the manager
    GenericProxyModel* mProxy = nullptr;
};

#endif // SUBJECTSMANAGER_H
