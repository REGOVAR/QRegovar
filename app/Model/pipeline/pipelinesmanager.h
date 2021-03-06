#ifndef PIPELINESMANAGER_H
#define PIPELINESMANAGER_H

#include <QtCore>
#include "pipelineslistmodel.h"
#include "pipeline.h"

class PipelinesManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PipelinesListModel* allPipes READ allPipes NOTIFY allPipesChanged)
    Q_PROPERTY(PipelinesListModel* intalledPipes READ intalledPipes NOTIFY intalledPipesChanged)

public:
    // Constructor
    PipelinesManager(QObject* parent=nullptr);

    // Getters
    inline PipelinesListModel* allPipes() const { return mAllPipes; }
    inline PipelinesListModel* intalledPipes() const { return mInstalledPipes; }

    // Method
    Q_INVOKABLE void loadJson(const QJsonArray& json);
    Q_INVOKABLE Pipeline* getOrCreatePipe(int pipeId);
    Q_INVOKABLE void install(int fileId);
    Q_INVOKABLE void uninstall(Pipeline* pipeline);


Q_SIGNALS:
    void allPipesChanged();
    void intalledPipesChanged();


public Q_SLOTS:
    //! Called by NetworkManager when need to process WebSocket messages managed by SampleManager
    void processPushNotification(QString action, QJsonObject data);



private:
    //! List of all pipelines on the server (all status)
    PipelinesListModel* mAllPipes = nullptr;
    //! List of pipelines that are installed and ready to used on the Regovar server
    PipelinesListModel* mInstalledPipes = nullptr;
    //! Internal collection of all loaded events
    QHash<qint64, Pipeline*> mPipelines;
};

#endif // PIPELINESMANAGER_H
