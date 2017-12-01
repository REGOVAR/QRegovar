#ifndef ANALYSESMANAGER_H
#define ANALYSESMANAGER_H

#include <QtCore>
#include "analysis.h"


class FilteringAnalysis;
class PipelineAnalysis;

class AnalysesManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PipelineAnalysis* newPipeline READ newPipeline NOTIFY newPipelineChanged)
    Q_PROPERTY(FilteringAnalysis* newFiltering READ newFiltering NOTIFY newFilteringChanged)

public:
    // Constructors
    explicit AnalysesManager(QObject* parent=nullptr);

    // Getters
    inline PipelineAnalysis* newPipeline() const { return mNewPipeline; }
    inline FilteringAnalysis* newFiltering() const { return mNewFiltering; }

    // Methods
    Q_INVOKABLE FilteringAnalysis* getOrCreateFilteringAnalysis(int id);
    Q_INVOKABLE PipelineAnalysis* getOrCreatePipelineAnalysis(int id);

    FilteringAnalysis* getFilteringAnalysis(int id);
    PipelineAnalysis* getPipelineAnalysis(int id);

    void resetNewFiltering(int refId);
    void resetNewPipeline();
    bool newAnalysis(QString type);

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
