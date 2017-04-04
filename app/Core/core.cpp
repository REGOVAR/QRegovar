#include "core.h"



Core* Core::mInstance = Q_NULLPTR;
Core* Core::i()
{
    if (mInstance == Q_NULLPTR)
    {
        mInstance = new Core();
    }
    return mInstance;
}

Core::Core()
{
    // Get managers.
    mApiManager = new RestApiManager();




}


void Core::init()
{
    // Init managers
    mApiManager->init();

    // Init model
    mUser = new User();
    mUser->id(1);
    mUser->firstname("Olivier");
    mUser->lastname("Gueudelot");
}

