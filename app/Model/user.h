#ifndef USERMODEL_H
#define USERMODEL_H
#include <QtCore>





/*!
 * \brief Define a user of the application.
 */
class User : public QObject
{
    Q_OBJECT
public:
    enum UserRight
    {
        None  = 0,
        Read  = 1,
        Write = 2
    };
    Q_ENUM(UserRight)

    enum UserRole
    {
        Administration,
        Project,
        Pipeline
    };
    Q_ENUM(UserRole)

    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY userChanged)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY userChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY userChanged)
    Q_PROPERTY(QString login READ login WRITE setLogin NOTIFY userChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY userChanged)
    Q_PROPERTY(QString function READ function WRITE setFunction NOTIFY userChanged)
    Q_PROPERTY(QString location READ location WRITE setLocation NOTIFY userChanged)
    Q_PROPERTY(QDateTime lastActivity READ lastActivity WRITE setLastActivity NOTIFY userChanged)

    // Constructors
    User(QObject* parent=nullptr);
    User(quint32 id, const QString& firstname, const QString& lastname, QObject* parent=nullptr);


    // Getters
    inline const QString& lastname() const { return mLastname; }
    inline const QString& firstname() const { return mFirstname; }
    inline const QString& email() const { return mEmail; }
    inline const QString& login() const { return mLogin; }
    inline const QString& password() const { return mPassword; }
    inline const QString& function() const { return mFunction; }
    inline const QString& location() const { return mLocation; }
    inline const QDateTime& lastActivity() const { return mLastActivity; }
    // Setters
    inline void setLastname(const QString& lastname) { mLastname = lastname; emit userChanged(); }
    inline void setFirstname(const QString& firstname) { mFirstname = firstname; emit userChanged(); }
    inline void setEmail(const QString& email) { mEmail = email; emit userChanged(); }
    inline void setLogin(const QString& login) { mLogin = login; emit userChanged(); }
    inline void setPassword(const QString& password) { mPassword = password; emit userChanged(); }
    inline void setFunction(const QString& function) { mFunction = function; emit userChanged(); }
    inline void setLocation(const QString& location) { mLocation = location; emit userChanged(); }
    inline void setLastActivity(const QDateTime& lastActivity) { mLastActivity = lastActivity; emit userChanged(); }


    // Methods
    // Init user data according to provided json return by api rest for authentication
    bool fromJson(QJsonDocument json);
    bool fromJson(QJsonObject json);
    // Reset value to anonymous. Should be used to logout the current user
    void clear();
    void save();
    bool isValid();

    // User's right tools
    bool isAdmin();
    UserRight role(const UserRole& role);
    void setRole(const UserRole& role, const UserRight& right);

Q_SIGNALS:
    void userChanged();

protected:
    int mId = -1;
    QString mFirstname;
    QString mLastname;
    QString mEmail;
    QString mLogin;
    QString mPassword;
    QString mFunction;
    QString mLocation;
    QDateTime mLastActivity;
    QHash<UserRole, UserRight> mRoles;

    // Internal method used to build user role model from json dictionary
    void setRole(const QString& role, const QString& right);
};

#endif // USERMODEL_H
