#include "analysis.h"

Analysis::Analysis(QObject* parent) : QObject(parent)
{
    mMenuModel = new RootMenu(this);
}
