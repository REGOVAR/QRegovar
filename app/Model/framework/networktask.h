#ifndef NETWORKTASK_H
#define NETWORKTASK_H

#include <QObject>
#include "request.h"

class NetworkTask : public QObject
{
    Q_OBJECT


public:
    enum TaskType
    {
        simpleRequest=0,
        fileDownload,
        fileUpload,
        importerRun,
        reporterRun,
        exporterRun,
        jobRun,
        pipelineInstallation,
        // Creation of the wt table
        filteringInit,
        // Update of the wt table (saving new filter by example)
        filteringUpdate,
        // Creation of the wt_tmp table
        filteringPrepare,
    };
    Q_ENUMS(TaskType)

    // Constructors
    NetworkTask(QObject* parent=nullptr);


private:
    Request* mRequest = nullptr;
    QString mLabel;
    TaskType mType;
    QUrl mUrl;
    float mProgress;
    bool mSuccess;
    bool mLoading;


    QDateTime mCreation;
    QDateTime mLastUpdate;
};

#endif // NETWORKTASK_H
