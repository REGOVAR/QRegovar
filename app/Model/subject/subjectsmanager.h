#ifndef SUBJECTSMANAGER_H
#define SUBJECTSMANAGER_H

#include <QtCore>
#include "subject.h"

class SubjectsManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)
    Q_PROPERTY(QList<QObject*> subjectsList READ subjectsList NOTIFY subjectsListChanged)
    Q_PROPERTY(QList<QObject*> subjectsOpenList READ subjectsOpenList NOTIFY subjectsOpenListChanged)
    Q_PROPERTY(Subject* subjectOpen READ subjectOpen NOTIFY subjectOpenChanged)
    Q_PROPERTY(int subjectOpenIndex READ subjectOpenIndex NOTIFY subjectOpenChanged)

public:
    // Constructor
    explicit SubjectsManager(QObject* parent = nullptr);

    // Getters
    inline QString searchQuery() const { return mSearchQuery; }
    inline QList<QObject*> subjectsList() const { return mSubjectsList; }
    inline QList<QObject*> subjectsOpenList() const { return mSubjectsOpenList; }
    inline Subject* subjectOpen() const { return mSubjectOpen; }
    inline int subjectOpenIndex() const { return mSubjectOpenIndex; }

    // Setters
    void setSearchQuery(QString val);

    // Methods
    Q_INVOKABLE Subject* getOrCreateSubject(int id);
    Q_INVOKABLE void newSubject(QString identifier, QString firstname, QString lastname, int sex, QString dateOfBirth, QString familyNumber, QString comment);
    Q_INVOKABLE void openSubject(int id);
    //Q_INVOKABLE void openSubject(QJsonObject json);
    Q_INVOKABLE void refreshSubjectsList();

Q_SIGNALS:
    // Property changed event
    void searchQueryChanged();
    void subjectsListChanged();
    void subjectsOpenListChanged();
    void subjectOpenChanged(int idx);
    //! Event on subject creation done (sync with server done)
    void subjectCreationDone(bool success, int subjectId);

private:
    //! List of subjects
    QList<QObject*> mSubjectsList;
    //! List of subject open
    QList<QObject*> mSubjectsOpenList;
    //! Query use to search subjects in the browser
    QString mSearchQuery;
    //! The model of the subject currently open
    Subject* mSubjectOpen = nullptr;
    //! The index of the open subject in the list
    int mSubjectOpenIndex = -1;
};

#endif // SUBJECTSMANAGER_H
