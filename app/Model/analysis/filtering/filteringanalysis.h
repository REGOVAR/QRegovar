#ifndef FILTERINGANALYSIS_H
#define FILTERINGANALYSIS_H

#include <QObject>
#include "../analysis.h"
#include "resultstreemodel.h"
#include "annotationstreemodel.h"
#include "quickfilters/quickfiltermodel.h"
#include "Model/sample/sample.h"

class ResultsTreeModel;

class FilteringAnalysis : public Analysis
{
    Q_OBJECT
    Q_PROPERTY(LoadingStatus status READ status NOTIFY statusChanged)
    Q_PROPERTY(AnnotationsTreeModel* annotations READ annotations NOTIFY annotationsUpdated)
    Q_PROPERTY(QString filter READ filter WRITE setFilter NOTIFY filterUpdated)
    Q_PROPERTY(QStringList fields READ fields NOTIFY fieldsUpdated)
    Q_PROPERTY(ResultsTreeModel* results READ results NOTIFY resultsUpdated)
    Q_PROPERTY(QuickFilterModel* quickfilters READ quickfilters NOTIFY quickfiltersUpdated)
    Q_PROPERTY(QStringList samples READ displayedSamples() NOTIFY samplesUpdated)
    Q_PROPERTY(bool sampleColumnDisplayed READ sampleColumnDisplayed() NOTIFY sampleColumnDisplayedUpdated)

public:
    enum LoadingStatus
    {
        empty,
        loadingAnnotations,
        LoadingResults,
        ready,
        error
    };

    // Constructor
    explicit FilteringAnalysis(QObject *parent = nullptr);

    // Getters
    inline LoadingStatus status() { return mUIStatus; }
    inline AnnotationsTreeModel* annotations() { return mAnnotations; }
    inline QString filter() { return mFilter; }
    inline QStringList fields() { return mFields; }
    inline ResultsTreeModel* results() { return mResults; }
    inline QuickFilterModel* quickfilters() { return mQuickFilters; }
    inline QList<Sample*> samples() { return mSamples; }
    inline QStringList displayedSamples() { QStringList result; foreach (Sample* sp, mSamples) { result << sp->name();}  return result; }
    inline bool sampleColumnDisplayed() { return mSampleColumnDisplayed; }

    // Setters
    Q_INVOKABLE inline void setFilter(QString filter) { mFilter = filter; emit filterUpdated(); }
    Q_INVOKABLE int setField(QString uid, bool isDisplayed, int order=-1);

    // Methods
    bool fromJson(QJsonObject json);
    Q_INVOKABLE inline int fieldsCount() { return mFields.count(); }



Q_SIGNALS:
    void isLoading();
    void statusChanged(LoadingStatus oldSatus, LoadingStatus newStatus);
    void annotationsUpdated();
    void filterUpdated();
    void fieldsUpdated();
    void resultsUpdated();
    void quickfiltersUpdated();
    void samplesUpdated();
    void sampleColumnDisplayedUpdated();


public Q_SLOTS:
    void asynchLoading(LoadingStatus oldSatus, LoadingStatus newStatus);


private:
    // Attributes
    int mRefId;
    QString mRefName;
    QStringList mFields;
    QString mFilter;
    QList<Sample*> mSamples;
    bool mSampleColumnDisplayed;

    LoadingStatus mUIStatus;
    ResultsTreeModel* mResults;
    AnnotationsTreeModel* mAnnotations;
    QuickFilterModel* mQuickFilters;

    // Methods
    void loadAnnotations();
    void loadResults();
};

#endif // FILTERINGANALYSIS_H
