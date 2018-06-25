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
    // Constructor
    PipelinesManager(QObject* parent=nullptr);

    // Getters
    inline PipelinesListModel* availablePipes() const { return mAvailablePipes; }
    inline PipelinesListModel* intalledPipes() const { return mInstalledPipes; }

    // Method
    Q_INVOKABLE void loadJson(QJsonArray json);
    Q_INVOKABLE Pipeline* getOrCreatePipe(int pipeId);
    Q_INVOKABLE Pipeline* install(int fileId);


Q_SIGNALS:
    void availablePipesChanged();
    void intalledPipesChanged();

public Q_SLOTS:
    // Called by NetworkManager when need to process WebSocket messages managed by SampleManager
    void processPushNotification(QString action, QJsonObject data);


private:
    //! List of all available pipelines (on shared server/github)
    PipelinesListModel* mAvailablePipes = nullptr;
    //! List of pipelines that are installed and ready to used on the Regovar server
    PipelinesListModel* mInstalledPipes = nullptr;
    //! Internal collection of all loaded events
    QHash<qint64, Pipeline*> mPipelines;
};

#endif // PIPELINESMANAGER_H
