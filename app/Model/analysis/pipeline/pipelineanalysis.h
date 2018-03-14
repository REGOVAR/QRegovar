#ifndef PIPELINEANALYSIS_H
#define PIPELINEANALYSIS_H

#include <QtCore>
#include "Model/analysis/analysis.h"
#include "Model/pipeline/pipeline.h"

class PipelineAnalysis: public Analysis
{
    Q_OBJECT
    Q_PROPERTY(Pipeline* pipeline READ pipeline WRITE setPipeline NOTIFY pipelineChanged)
    Q_PROPERTY(QList<QObject*> inputsFilesList READ inputsFilesList NOTIFY inputsFilesListChanged)


public:
    // Constructors
    explicit PipelineAnalysis(QObject* parent=nullptr);
    explicit PipelineAnalysis(int id, QObject* parent=nullptr);

    // Getters
    inline Pipeline* pipeline() const { return mPipeline; }
    inline QList<QObject*> inputsFilesList() const { return mInputsFilesList; }

    // Setters
    void setPipeline(Pipeline* pipe);


    // Analysis Abstracty Methods overriden
    Q_INVOKABLE inline bool fromJson(QJsonObject, bool) { return true; }
    Q_INVOKABLE inline QJsonObject toJson() { return QJsonObject(); }
    Q_INVOKABLE inline void save() { return; }
    Q_INVOKABLE inline void load(bool) { return; }

    // Methods
    Q_INVOKABLE void addInputs(QList<QObject*> inputs);
    Q_INVOKABLE void removeInputs(QList<QObject*> inputs);
    Q_INVOKABLE void addInputFromWS(QJsonObject json);

public Q_SLOTS:
    void processPushNotification(QString action, QJsonObject data);

Q_SIGNALS:
    void pipelineChanged();
    void inputsFilesListChanged();


private:
    //! The pipeline used for the analysis
    Pipeline* mPipeline = nullptr;
    //! The list of files used as input for the analysis
    QList<QObject*> mInputsFilesList;
    QList<int> mInputsFilesIds;

};

#endif // PIPELINEANALYSIS_H
