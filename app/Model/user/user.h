#ifndef USERMODEL_H
#define USERMODEL_H
#include <QtCore>





/*!
 * \brief Define a user of the application.
 */
class User : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY dataChanged)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY dataChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY dataChanged)
    Q_PROPERTY(QString login READ login WRITE setLogin NOTIFY dataChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY dataChanged)
    Q_PROPERTY(QString function READ function WRITE setFunction NOTIFY dataChanged)
    Q_PROPERTY(QString location READ location WRITE setLocation NOTIFY dataChanged)
    Q_PROPERTY(QDateTime creationDate READ creationDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime lastActivity READ lastActivity NOTIFY dataChanged)
    Q_PROPERTY(bool isActive READ isActive WRITE setIsActive NOTIFY dataChanged)
    Q_PROPERTY(bool isAdmin READ isAdmin WRITE setIsAdmin NOTIFY dataChanged)
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)

public:
    // Constructors
    User(QObject* parent=nullptr);
    User(int id, QObject* parent=nullptr);
    User(int id, const QString& firstname, const QString& lastname, QObject* parent=nullptr);

    // Getters
    inline int id() const { return mId; }
    inline QString lastname() const { return mLastname; }
    inline QString firstname() const { return mFirstname; }
    inline QString email() const { return mEmail; }
    inline QString login() const { return mLogin; }
    inline QString password() const { return mPassword; }
    inline QString function() const { return mFunction; }
    inline QString location() const { return mLocation; }
    inline QDateTime creationDate() const { return mCreationDate; }
    inline QDateTime lastActivity() const { return mLastActivity; }
    inline bool isActive() const { return mIsActive; }
    inline bool isAdmin() const { return mIsAdmin; }
    inline QString searchField() const { return mSearchField; }

    // Setters
    inline void setLastname(const QString& lastname) { mLastname = lastname; emit dataChanged(); }
    inline void setFirstname(const QString& firstname) { mFirstname = firstname; emit dataChanged(); }
    inline void setEmail(const QString& email) { mEmail = email; emit dataChanged(); }
    inline void setLogin(const QString& login) { mLogin = login; emit dataChanged(); }
    inline void setPassword(const QString& password) { mPassword = password; emit dataChanged(); }
    inline void setFunction(const QString& function) { mFunction = function; emit dataChanged(); }
    inline void setLocation(const QString& location) { mLocation = location; emit dataChanged(); }
    inline void setIsActive(const bool flag) { mIsActive = flag; emit dataChanged(); }
    inline void setIsAdmin(const bool flag) { mIsAdmin = flag; emit dataChanged(); }


    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson(bool withPassword=false);
    //! Save event information onto server
    Q_INVOKABLE void save(bool withPassword=false);
    //! Load event information and related object from server
    Q_INVOKABLE void load(bool forceRefresh=true);
    //! Reset value to anonymous. Should be used to logout the current user
    Q_INVOKABLE void clear();
    //! Return true if the current user valid (login success, active and loaded data ok); false otherwise
    Q_INVOKABLE bool isValid();

Q_SIGNALS:
    void dataChanged();

public Q_SLOTS:
    void updateSearchField();

protected:
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();

    int mId = -1;
    QString mFirstname;
    QString mLastname;
    QString mEmail;
    QString mLogin;
    QString mPassword;
    QString mFunction;
    QString mLocation;
    QDateTime mCreationDate;
    QDateTime mLastActivity;
    bool mIsActive = false;
    bool mIsAdmin = false;
    QString mSearchField;
};

#endif // USERMODEL_H
