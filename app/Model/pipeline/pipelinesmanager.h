#ifndef PIPELINESMANAGER_H
#define PIPELINESMANAGER_H

#include <QtCore>
#include "pipelineslistmodel.h"
#include "pipeline.h"

class PipelinesManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PipelinesListModel* availablePipes READ availablePipes NOTIFY availablePipesChanged)
    Q_PROPERTY(PipelinesListModel* intalledPipes READ intalledPipes NOTIFY intalledPipesChanged)

public:
    explicit PipelinesManager(QObject* parent=nullptr);

    // Getters
    inline PipelinesListModel* availablePipes() const { return mAvailablePipes; }
    inline PipelinesListModel* intalledPipes() const { return mInstalledPipes; }

    // Method
    void loadJson(QJsonArray json);
    Pipeline* getOrCreatePipe(int eventId);


Q_SIGNALS:
    void availablePipesChanged();
    void intalledPipesChanged();

public Q_SLOTS:
    // Called by NetworkManager when need to process WebSocket messages managed by SampleManager
    void processPushNotification(QString action, QJsonObject data);


private:
    //! List of all available pipelines (on shared server/github)
    PipelinesListModel* mAvailablePipes;
    //! List of pipelines that are installed and ready to used on the Regovar server
    PipelinesListModel* mInstalledPipes;
    //! Internal collection of all loaded events
    QHash<qint64, Pipeline*> mEvents;
};

#endif // PIPELINESMANAGER_H
