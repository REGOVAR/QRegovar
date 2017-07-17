#ifndef REGOVARMODEL_H
#define REGOVARMODEL_H

#include <QSettings>
#include <QNetworkReply>
#include <QAuthenticator>
#include "project/projectsbrowsermodel.h"


#ifndef regovar
#define regovar (RegovarModel::i())
#endif



/*!
 * \brief Singleton.
 * Main Regovar's client core. Wrap models and manage all interaction with the server
 * (websocket, rest api, tus resumable upload, and so on.
 */
class RegovarModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ProjectsBrowserModel* projectsBrowser READ projectsBrowser NOTIFY projectsBrowserUpdated)

public:
    static RegovarModel* i();
    void init();
    void readSettings();
    void writeSettings();



    // Accessors
    inline QUrl& apiRootUrl() { return mApiRootUrl; }
    inline ProjectsBrowserModel* projectsBrowser() const { return mProjectsBrowser; }
    //inline UserModel* currentUser() const { return mUser; }



/*
public Q_SLOTS:
    void login(QString& login, QString& password);
    void logout();
    void authenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);
*/

Q_SIGNALS:
    void loginSuccess();
    void loginFailed();
    void logoutSuccess();
    void projectsBrowserUpdated();


private:
    RegovarModel();
    ~RegovarModel();
    static RegovarModel* mInstance;



    // Models
    //! The root url to the server api
    QUrl mApiRootUrl;
    //! The current user of the application
    // UserModel * mUser;
    //! The model of the projects browser treeview
    ProjectsBrowserModel* mProjectsBrowser;

};


#endif // REGOVARMODEL_H
