#ifndef REGOVARCONTROLSPLUGIN_H
#define REGOVARCONTROLSPLUGIN_H
#include <QQmlExtensionPlugin>
#include <QQmlEngine>

class RegovarControlsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri);

};

#endif // REGOVARCONTROLSPLUGIN_H
