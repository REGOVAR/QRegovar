#ifndef CORE_H
#define CORE_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include "model/user.h"


class RestApiManager;


/*!
 * \brief Singleton.
 * Main Regovar's client core. Wrap the model and manage all interaction with the server
 * (websocket, rest api, tus resumable upload, and so on.
 */
class Core : public QObject
{
    Q_OBJECT

public:
    static Core* i();
    void init();
    void readSettings();
    void writeSettings();



    // Manager
    //! Manage all call to the Regovar rest api. Enqueue request, and return a pointer to the answer, answer emit a signal when it gets response/error
    inline QUrl& apiRootUrl() { return mApiRootUrl; }

    // task... get list of tasks on the server, emit when task progress is ok




    // Model
    inline User* currentUser() { return mUser; }


public Q_SLOTS:
    void login(QString& login, QString& password);
    void logout();
    static void authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);


Q_SIGNALS:
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();


private:
    Core();
    static Core* mInstance;



    // Managers
    RestApiManager* mApiManager;

    // Model
    //! The root url to the server api
    QUrl mApiRootUrl;
    //! The current user of the application
    User* mUser;

};


#include "managers/restapimanager.h"

#endif // CORE_H
