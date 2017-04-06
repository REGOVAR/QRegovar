#ifndef APP_H
#define APP_H

#include <QObject>
#include "../libs/QtAwesome/QtAwesome.h"

#ifndef app
#define app (App::i())
#endif

/*!
 * \brief Singleton class containing ui tools that need to be accessed from everywhere
 */
class App : public QObject
{
    Q_OBJECT
public:
    static App* i();
    static QtAwesome* awesome();

private:
    explicit App(QObject* parent = 0);
    static App* mInstance;
    static QtAwesome* mAwesome;
};

#endif // APP_H
