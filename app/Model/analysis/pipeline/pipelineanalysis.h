#ifndef PIPELINEANALYSIS_H
#define PIPELINEANALYSIS_H

#include <QtCore>
#include "Model/analysis/analysis.h"
#include "Model/pipeline/pipeline.h"
#include "Model/file/fileslistmodel.h"

class PipelineAnalysis: public Analysis
{
    Q_OBJECT
    // Regovar resource attribute
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    // PipelineAnalysis (Job) attribute
    Q_PROPERTY(QJsonObject config READ config WRITE setConfig NOTIFY neverChanged)
    Q_PROPERTY(double progressValue READ progressValue NOTIFY dataChanged)
    Q_PROPERTY(QString progressLabel READ progressLabel NOTIFY dataChanged)

    Q_PROPERTY(Pipeline* pipeline READ pipeline WRITE setPipeline NOTIFY pipelineChanged)
    Q_PROPERTY(FilesListModel* inputsFiles READ inputsFiles NOTIFY neverChanged)
    Q_PROPERTY(FilesListModel* outputsFiles READ outputsFiles NOTIFY neverChanged)

public:
    // Constructors
    explicit PipelineAnalysis(QObject* parent=nullptr);
    explicit PipelineAnalysis(int id, QObject* parent=nullptr);

    // Getters
    inline bool loaded() const { return mLoaded; }

    inline QJsonObject config() const { return mConfig; }
    inline double progressValue() const { return mProgressValue; }
    inline QString progressLabel() const { return mProgressLabel; }
    inline Pipeline* pipeline() const { return mPipeline; }
    inline FilesListModel* inputsFiles() const { return mInputsFiles; }
    inline FilesListModel* outputsFiles() const { return mOutputsFiles; }

    // Setters
    inline void setConfig(QJsonObject config) { mConfig = config; emit dataChanged(); }
    void setPipeline(Pipeline* pipe);


    // Analysis Abstracty Methods overriden
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
    void neverChanged();
    void pipelineChanged();
    void dataChanged();


private:
    bool mLoaded = false;
    QDateTime mUpdateDate;
    QDateTime mCreateDate;
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();

    // Attributes
    QJsonObject mConfig;
    double mProgressValue = 0;
    QString mProgressLabel;

    //! The pipeline used for the analysis
    Pipeline* mPipeline = nullptr;
    //! The list of files used as input for the analysis
    FilesListModel* mInputsFiles = nullptr;
    //! The list of files created by the analysis
    FilesListModel* mOutputsFiles = nullptr;

};

#endif // PIPELINEANALYSIS_H
