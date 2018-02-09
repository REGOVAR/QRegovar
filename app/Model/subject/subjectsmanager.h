#ifndef SUBJECTSMANAGER_H
#define SUBJECTSMANAGER_H

#include <QtCore>
#include "subject.h"

class SubjectsManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)
    Q_PROPERTY(QList<QObject*> subjectsList READ subjectsList NOTIFY subjectsListChanged)

public:
    // Constructor
    explicit SubjectsManager(QObject* parent = nullptr);

    // Getters
    inline QString searchQuery() const { return mSearchQuery; }
    inline QList<QObject*> subjectsList() const { return mSubjectsList; }

    // Setters
    void setSearchQuery(QString val);

    // Methods
    Q_INVOKABLE Subject* getOrCreateSubject(int id);
    Q_INVOKABLE void newSubject(QString identifier, QString firstname, QString lastname, int sex, QString dateOfBirth, QString familyNumber, QString comment);
    Q_INVOKABLE void openSubject(int id);
    //! refresh models with data from server
    Q_INVOKABLE void refresh();

Q_SIGNALS:
    // Property changed event
    void searchQueryChanged();
    void subjectsListChanged();
    //! Event on subject creation done (sync with server done)
    void subjectCreationDone(bool success, int subjectId);

private:
    //! List of subjects
    QList<QObject*> mSubjectsList;
    //! Query use to search subjects in the browser
    QString mSearchQuery;
};

#endif // SUBJECTSMANAGER_H
