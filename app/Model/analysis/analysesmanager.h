#ifndef ANALYSESMANAGER_H
#define ANALYSESMANAGER_H

#include <QtCore>
#include "analysis.h"
#include "analyseslistmodel.h"


class FilteringAnalysis;
class PipelineAnalysis;

class AnalysesManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PipelineAnalysis* newPipeline READ newPipeline NOTIFY newPipelineChanged)
    Q_PROPERTY(FilteringAnalysis* newFiltering READ newFiltering NOTIFY newFilteringChanged)
    Q_PROPERTY(QString filteringType READ filteringType)
    Q_PROPERTY(QString pipelineType READ pipelineType)
public:
    // Constructors
    AnalysesManager(QObject* parent=nullptr);

    // Getters
    inline PipelineAnalysis* newPipeline() const { return mNewPipeline; }
    inline FilteringAnalysis* newFiltering() const { return mNewFiltering; }
    inline QString filteringType() const { return Analysis::FILTERING; }
    inline QString pipelineType() const { return Analysis::PIPELINE; }

    // Methods
    Q_INVOKABLE FilteringAnalysis* getOrCreateFilteringAnalysis(int id);
    Q_INVOKABLE PipelineAnalysis* getOrCreatePipelineAnalysis(int id);

    Q_INVOKABLE FilteringAnalysis* getFilteringAnalysis(int id);
    Q_INVOKABLE PipelineAnalysis* getPipelineAnalysis(int id);

    Q_INVOKABLE void deleteFilteringAnalysis(int id);
    Q_INVOKABLE void deletePipelineAnalysis(int id);

    Q_INVOKABLE void resetNewFiltering(int refId);
    Q_INVOKABLE void resetNewPipeline();
    Q_INVOKABLE bool newAnalysis(QString type);
    bool loadJson(const QJsonArray& json);

public Q_SLOTS:
    bool openAnalysis(QString type, int id, bool reload_from_server=true);

Q_SIGNALS:
    void analysisCreationDone(bool success, int analysisId);
    void newPipelineChanged();
    void newFilteringChanged();

private:
    // Creation Wizards Models
    //! model to hold data when using form to create a new analysis
    PipelineAnalysis* mNewPipeline = nullptr;
    FilteringAnalysis* mNewFiltering = nullptr;

    // Internal collection of all loaded analyses.
    QHash<int, FilteringAnalysis*> mFilteringAnalyses;
    QHash<int, PipelineAnalysis*> mPipelineAnalyses;
};

#endif // ANALYSESMANAGER_H
