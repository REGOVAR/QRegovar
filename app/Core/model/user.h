#ifndef USER_H
#define USER_H
#include <QtCore>
#include <QPixmap>


/*!
 * \brief Define a user of the application.
 */
class User
{
public:
    // Constructors
    User();
    User(quint32 id, const QString& firstname, const QString& lastname);

    // Properties
    // Read
    quint32 id() const;
    const QString& lastname() const;
    const QString& firstname() const;
    const QString& email() const;
    const QString& login() const;
    const QString& password() const;
    const QPixmap& avatar() const;
    const QString& function() const;
    const QString& location() const;
    const QDate& lastActivity() const;
    // Write
    void setId(quint32 id);
    void setLastname(const QString& lastname);
    void setFirstname(const QString& firstname);
    void setEmail(const QString& email);
    void setLogin(const QString& login);
    void setPassword(const QString& password);
    void setAvatar(const QPixmap& avatar);
    void setFunction(const QString& function);
    void setLocation(const QString& location);
    void setLastActivity(const QDate& lastActivity);


    // Methods
    // Check if the user model is valid or not
    bool isValid() const;



protected:
    quint32 mId = -1;
    QString mFirstname;
    QString mLastname;
    QString mEmail;
    QString mLogin;
    QString mPassword;
    QPixmap mAvatar;
    QString mFunction;
    QString mLocation;
    QDate mLastActivity;
    QMap<QString, bool> mAuth;
};

#endif // USER_H
