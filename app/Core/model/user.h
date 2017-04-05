#ifndef USER_H
#define USER_H
#include <QtCore>

class User
{
public:
    User();
    User(quint32 id, const QString& firstname, const QString& lastname);

    // Read
    quint32 id() const;
    const QString& lastname() const;
    const QString& firstname() const;


    // Write
    void setId(quint32 id);
    void setLastname(const QString &lastname);
    void setFirstname(const QString &firstname);

    bool isValid() const;


protected:
    quint32 mId = -1;
    QString mFirstname;
    QString mLastname;

};

#endif // USER_H
