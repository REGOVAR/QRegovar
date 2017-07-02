#include "regovarcontrolsplugin.h"
#include "showcase.h"
#include "RegovarModel.h"
#include <QDebug>

void RegovarControlsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("RegovarControls"));
    qmlRegisterType<ShowCase>(uri, 1, 0, "ShowCase");
    qmlRegisterType<RegovarModel>(uri, 1, 0, "RegovarModel");

}

