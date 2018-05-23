#ifndef USERSMANAGER_H
#define USERSMANAGER_H

#include <QtCore>
#include "userslistmodel.h"
#include "user.h"

class UsersManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(UsersListModel* users READ users NOTIFY usersChanged)
    Q_PROPERTY(User* user READ user WRITE setUser NOTIFY userChanged)
    Q_PROPERTY(User* newUser READ newUser NOTIFY userChanged)
    Q_PROPERTY(bool keepMeLogged READ keepMeLogged WRITE setKeepMeLogged NOTIFY keepMeLoggedChanged)

public:
    // Constructor
    explicit UsersManager(QObject* parent=nullptr);

    // Getters
    inline UsersListModel* users() const { return mUsersList; }
    inline User* user() const { return mUser; }
    inline User* newUser() const { return mNewUser; }
    inline bool keepMeLogged() const { return mKeepMeLogged; }

    // Setters
    inline void setUser(User* user) { mUser = user; emit userChanged(); }
    inline void setKeepMeLogged(bool flag) { mKeepMeLogged = flag; emit keepMeLoggedChanged(); }

    // Method
    void loadJson(QJsonArray json);
    Q_INVOKABLE User* getOrCreateUser(int userId);
    Q_INVOKABLE void switchLoginScreen(bool state);

Q_SIGNALS:
    void usersChanged();
    void userChanged();
    void keepMeLoggedChanged();
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();

    void displayLoginScreen(bool state);


public Q_SLOTS:
    //! Called by NetworkManager when need to process WebSocket messages managed by UsersManager
    void processPushNotification(QString action, QJsonObject data);
    //! try to log the user with provided credentials
    void login(QString login, QString password);
    //! try to log the user with session coockie
    void login();
    //! logout the current user
    void logout();

private:
    //! List of users
    UsersListModel* mUsersList = nullptr;
    //! The current user of the application
    User* mUser = nullptr;
    //! The model used to create new user (admin panel)
    User* mNewUser = nullptr;
    //! Restore user session at the start when true
    bool mKeepMeLogged = false;
    //! Internal collection of all loaded users
    QHash<int, User*> mUsers;

};

#endif // USERSMANAGER_H
