#include "analysis.h"



QString Analysis::FILTERING = QString("analysis");
QString Analysis::PIPELINE = QString("pipeline");
QHash<QString, QString> Analysis::sStatusLabelMap = Analysis::initStatusLabelMap();
QHash<QString, QString> Analysis::sStatusIconMap = Analysis::initStatusIconMap();
QHash<QString, bool> Analysis::sStatusAnimatedMap = Analysis::initStatusAnimatedMap();
QHash<QString, QString> Analysis::initStatusLabelMap()
{
    QHash<QString, QString> map;
    map.insert("empty",  tr("Initializing"));
    map.insert("waiting", tr("Waiting for inputs"));
    map.insert("initializing",  tr("Initializing"));
    map.insert("computing", tr("Computing database"));
    map.insert("running", tr("Running"));
    map.insert("pause", tr("Pause"));
    map.insert("finalizing", tr("Finalizing"));
    map.insert("done", tr("Done"));
    map.insert("ready", tr("Ready"));
    map.insert("close", tr("Close"));
    map.insert("canceled", "Canceled");
    map.insert("error", tr("Error"));

    return map;
}
QHash<QString, QString> Analysis::initStatusIconMap()
{
    QHash<QString, QString> map;
    map.insert("empty",  "I");
    map.insert("waiting", "I");
    map.insert("initializing",  "I");
    map.insert("computing", "/");
    map.insert("running", "/");
    map.insert("pause", "y");
    map.insert("finalizing", "I");
    map.insert("done", "n");
    map.insert("ready", "n");
    map.insert("close", "g");
    map.insert("canceled", "m");
    map.insert("error", "m");

    return map;
}
QHash<QString, bool> Analysis::initStatusAnimatedMap()
{
    QHash<QString, bool> map;
    map.insert("empty",  false);
    map.insert("waiting", false);
    map.insert("initializing",  true);
    map.insert("computing", true);
    map.insert("running", true);
    map.insert("pause", false);
    map.insert("finalizing", true);
    map.insert("done", false);
    map.insert("ready", false);
    map.insert("close", false);
    map.insert("canceled", false);
    map.insert("error", false);

    return map;
}


Analysis::Analysis(QObject* parent) : QObject(parent)
{
    mMenuModel = new RootMenu(this);
}



QString Analysis::statusLabel(QString status)
{
    if (sStatusLabelMap.contains(status))
    {
        return sStatusLabelMap[status];
    }
    return "";
}
QString Analysis::statusIcon(QString status)
{
    if (sStatusIconMap.contains(status))
    {
        return sStatusIconMap[status];
    }
    return "";
}
bool Analysis::statusIconAnimated(QString status)
{
    if (sStatusAnimatedMap.contains(status))
    {
        return sStatusAnimatedMap[status];
    }
    return "";
}
