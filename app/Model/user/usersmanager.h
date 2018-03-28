#ifndef USERSMANAGER_H
#define USERSMANAGER_H

#include <QtCore>
#include "userslistmodel.h"
#include "user.h"

class UsersManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(UsersListModel* users READ users NOTIFY usersChanged)
    Q_PROPERTY(User* user READ user NOTIFY userChanged)

public:
    // Constructor
    explicit UsersManager(QObject* parent=nullptr);

    // Getters
    inline UsersListModel* users() const { return mUsersList; }
    inline User* user() const { return mUser; }

    // Method
    void loadJson(QJsonArray json);
    Q_INVOKABLE User* getOrCreateUser(qint32 userId);
    Q_INVOKABLE void switchLoginScreen(bool state);

Q_SIGNALS:
    void usersChanged();
    void userChanged();
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();

    void displayLoginScreen(bool state);


public Q_SLOTS:
    //! Called by NetworkManager when need to process WebSocket messages managed by UsersManager
    void processPushNotification(QString action, QJsonObject data);
    //! try to lo the user with provided credentials
    void login(QString login, QString password);
    //! logout the current user
    void logout();

private:
    //! List of users
    UsersListModel* mUsersList;
    //! The current user of the application
    User* mUser = nullptr;
    //! Internal collection of all loaded users
    QHash<qint32, User*> mUsers;

};

#endif // USERSMANAGER_H
