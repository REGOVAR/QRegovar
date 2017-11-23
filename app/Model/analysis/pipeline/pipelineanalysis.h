#ifndef PIPELINEANALYSIS_H
#define PIPELINEANALYSIS_H

#include <QtCore>
#include "Model/analysis/analysis.h"

class PipelineAnalysis: public Analysis
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> inputsFilesList READ inputsFilesList NOTIFY inputsFilesListChanged)



public:
    // Constructors
    explicit PipelineAnalysis(QObject* parent=nullptr);
    explicit PipelineAnalysis(int id, QObject* parent=nullptr);

    // Getters
    inline QList<QObject*> inputsFilesList() const { return mInputsFilesList; }

    // Setters


    // Analysis Abstracty Methods overriden
    Q_INVOKABLE inline bool fromJson(QJsonObject, bool) { return true; }
    Q_INVOKABLE inline QJsonObject toJson() { return QJsonObject(); }
    Q_INVOKABLE inline void save() { return; }
    Q_INVOKABLE inline void load() { return; }

    // Methods
    Q_INVOKABLE void addInputs(QList<QObject*> inputs);
    Q_INVOKABLE void removeInputs(QList<QObject*> inputs);
    Q_INVOKABLE void addInputFromWS(QJsonObject json);


public Q_SLOTS:
    void onWebsocketMessageReceived(QString ,QJsonObject);

Q_SIGNALS:
    void inputsFilesListChanged();


private:
    //! The list of files used as input for the analysis
    QList<QObject*> mInputsFilesList;
    QList<int> mInputsFilesIds;

};

#endif // PIPELINEANALYSIS_H
