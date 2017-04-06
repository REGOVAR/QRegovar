#include "app.h"

App* App::mInstance = nullptr;
QtAwesome* App::mAwesome  = nullptr;

App* App::i()
{
    if (!mInstance)
    {
        mInstance = new App();
    }
    return mInstance;
}

QtAwesome* App::awesome()
{
    if (!mAwesome)
    {
        mAwesome = new QtAwesome();
        mAwesome->initFontAwesome();



    }
    return mAwesome;
}

App::App(QObject* parent) :
    QObject(parent)
{


}
