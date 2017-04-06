#ifndef USER_H
#define USER_H
#include <QtCore>
#include <QPixmap>


/*!
 * \brief Define a user of the application.
 */
class User : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY userChanged)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY userChanged)

    // Constructors
    User(QObject * parent = 0);
    User(quint32 id, const QString& firstname, const QString& lastname, QObject * parent = 0);

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
    // Init user data according to provided json return by api rest for authentication
    bool loginUser(QJsonDocument json);
    // Logout the user (reset value to anonymous)
    void logoutUser();

Q_SIGNALS:
    void userChanged();

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
