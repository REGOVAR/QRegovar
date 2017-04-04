#ifndef CORE_H
#define CORE_H

#include <QSettings>
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

    inline QSettings* settings() { return mSettings; }



    // Manager
    //! Manage all call to the Regovar rest api. Enqueue request, and return a pointer to the answer, answer emit a signal when it gets response/error
    inline RestApiManager* api() { return mApiManager; }

    // task... get list of tasks on the server, emit when task progress is ok




    // Model
    inline User* currentUser() { return mUser; }




private:
    Core();
    static Core* mInstance;

    // Settings of the application
    QSettings* mSettings;


    // Managers
    RestApiManager* mApiManager;

    // Model
    //! The current user of the application
    User* mUser;
    // mOnlineUsers : List of users that are currently online (connected to the server)
    // mUsers : list of all users populate this collection only when user need to display the userList panel

    // status : all status usefull for the client

};


#include "managers/restapimanager.h"

#endif // CORE_H
