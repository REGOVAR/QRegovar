#ifndef PIPELINEANALYSIS_H
#define PIPELINEANALYSIS_H

#include <QtCore>
#include "Model/analysis/analysis.h"
#include "Model/pipeline/pipeline.h"
#include "Model/file/fileslistmodel.h"
#include "Model/file/filestreemodel.h"
#include "Model/analysis/remotelogmodel.h"

class PipelineAnalysis: public Analysis
{
    Q_OBJECT
    // PipelineAnalysis (Job) attribute
    Q_PROPERTY(QJsonObject config READ config WRITE setConfig NOTIFY dataChanged)
    Q_PROPERTY(double progressValue READ progressValue NOTIFY dataChanged)
    Q_PROPERTY(QString progressLabel READ progressLabel NOTIFY dataChanged)

    Q_PROPERTY(Pipeline* pipeline READ pipeline WRITE setPipeline NOTIFY pipelineChanged)
    Q_PROPERTY(FilesListModel* inputsFiles READ inputsFiles NOTIFY dataChanged)
    Q_PROPERTY(FilesTreeModel* outputsFiles READ outputsFiles NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> logs READ logs NOTIFY statusChanged)

public:
    // Constructors
    explicit PipelineAnalysis(QObject* parent=nullptr);
    explicit PipelineAnalysis(int id, QObject* parent=nullptr);

    // Getters
    inline QJsonObject config() const { return mConfig; }
    inline double progressValue() const { return mProgressValue; }
    inline QString progressLabel() const { return mProgressLabel; }
    inline Pipeline* pipeline() const { return mPipeline; }
    inline FilesListModel* inputsFiles() const { return mInputsFiles; }
    inline FilesTreeModel* outputsFiles() const { return mOutputsFiles; }
    inline QList<QObject*> logs() const { return mLogs; }

    // Setters
    inline void setConfig(QJsonObject config) { mConfig = config; emit dataChanged(); }
    void setPipeline(Pipeline* pipe);


    // Analysis  abstracts methods overriden
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonObject json, bool full_init=false);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson();
    //! Save subject information onto server
    Q_INVOKABLE void save();
    //! Load Subject information from server
    Q_INVOKABLE void load(bool forceRefresh=true);

    // Methods
    Q_INVOKABLE void addInputs(QList<QObject*> inputs);
    Q_INVOKABLE void removeInputs(QList<QObject*> inputs);
    Q_INVOKABLE void addInputFromWS(QJsonObject json);
    //! Control the execution of the job (if supported by the container technology)
    Q_INVOKABLE void pause();
    Q_INVOKABLE void start();
    Q_INVOKABLE void cancel();
    Q_INVOKABLE void finalyze();
    Q_INVOKABLE void refreshMonitoring();

public Q_SLOTS:
    void processPushNotification(QString action, QJsonObject data);

Q_SIGNALS:
    void pipelineChanged();


private:
    // Attributes
    QJsonObject mConfig;
    double mProgressValue = 0;
    QString mProgressLabel;
    QList<QObject*> mLogs;

    //! The pipeline used for the analysis
    Pipeline* mPipeline = nullptr;
    //! The list of files used as input for the analysis
    FilesListModel* mInputsFiles = nullptr;
    //! The list of files created by the analysis
    //! Note that we use a tree even if we know that outputs is a list because the FileBrowser need a treemodel
    FilesTreeModel* mOutputsFiles = nullptr;
};

#endif // PIPELINEANALYSIS_H
