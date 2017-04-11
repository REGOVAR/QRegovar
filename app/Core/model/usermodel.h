#ifndef USERMODEL_H
#define USERMODEL_H
#include <QtCore>
#include <QPixmap>
#include "resourcemodel.h"


/*!
 * \brief Define a user of the application.
 */
class UserModel : public ResourceModel
{
    Q_OBJECT
public:
//    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY resourceChanged)
//    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY resourceChanged)

    // Constructors
    UserModel();
    UserModel(quint32 id, const QString& firstname, const QString& lastname);

    // Properties
    // Read
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
    // Init user data according to provided json return by api rest for authentication
    bool fromJson(QJsonDocument json);
    // Reset value to anonymous. Should be used to logout the current user
    void clear();


protected:
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

#endif // USERMODEL_H
