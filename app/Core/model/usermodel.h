#ifndef USERMODEL_H
#define USERMODEL_H
#include <QtCore>
#include <QPixmap>
#include "resourcemodel.h"


enum UserRight
{
    None  = 0,
    Read  = 1,
    Write = 2
};

enum UserRole
{
    Administration,
    Project,
    Pipeline
};


/*!
 * \brief Define a user of the application.
 */
class UserModel : public ResourceModel
{
    Q_OBJECT
public:
    enum
    {

    };


    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY userChanged)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY userChanged)

    // Constructors
    UserModel(QObject* parent=nullptr);
    UserModel(quint32 id, const QString& firstname, const QString& lastname, QObject* parent=nullptr);

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
    void save();

    // User's right tools
    bool isAdmin();
    UserRight role(const UserRole& role);
    void setRole(const UserRole& role, const UserRight& right);

Q_SIGNALS:
    void userChanged();

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
    QHash<UserRole, UserRight> mRoles;

    // Internal method used to build user role model from json dictionary
    void setRole(const QString& role, const QString& right);
};

#endif // USERMODEL_H
