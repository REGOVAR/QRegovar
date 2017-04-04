#ifndef USER_H
#define USER_H

#include <QObject>
#include <QStandardItemModel>

class User : public QStandardItemModel
{
    Q_OBJECT

public:
    User();

    // Read
    inline uint id() { return mId; }
    inline QString lastname() { return mLastname; }
    inline QString firstname() { return mFirstname; }

    // Write
    inline void id(uint newId) { mId=newId; }
    inline void lastname(QString newLastname) { mLastname=newLastname; }
    inline void firstname(QString newFirstname) { mFirstname=newFirstname; }


protected:
    uint mId;
    QString mLastname;
    QString mFirstname;

};

#endif // USER_H
