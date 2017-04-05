#ifndef CORE_H
#define CORE_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include "model/user.h"

#ifndef regovar
#define regovar (Regovar::i())
#endif

class RestApiManager;


/*!
 * \brief Singleton.
 * Main Regovar's client core. Wrap the model and manage all interaction with the server
 * (websocket, rest api, tus resumable upload, and so on.
 */
class Regovar : public QObject
{
    Q_OBJECT
    // seul les type de QVariant et les QObject peuvent etre des property.. enfin pour toi !
    Q_PROPERTY(User* currentUser READ currentUser NOTIFY loginSuccess)

public:
    static Regovar* i();
    void init();
    void readSettings();
    void writeSettings();



    // Manager
    //! Manage all call to the Regovar rest api. Enqueue request, and return a pointer to the answer, answer emit a signal when it gets response/error
    inline QUrl& apiRootUrl() { return mApiRootUrl; }

    // task... get list of tasks on the server, emit when task progress is ok


    // Model
     User * currentUser() const { return mUser; }



public Q_SLOTS:
    void login(QString& login, QString& password);
    void logout();
    void authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);


Q_SIGNALS:
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();


private:
    Regovar();
    ~Regovar();
    static Regovar* mInstance;



    // Managers
    RestApiManager* mApiManager;

    // Model
    //! The root url to the server api
    QUrl mApiRootUrl;
    //! The current user of the application
    User * mUser;

};


#include "managers/restapimanager.h"

#endif // CORE_H
