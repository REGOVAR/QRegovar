#ifndef FILTERINGANALYSIS_H
#define FILTERINGANALYSIS_H

#include <QObject>
#include "../analysis.h"
#include "resultstreemodel.h"
#include "annotationstreemodel.h"
#include "remotesampletreemodel.h"
#include "quickfilters/quickfiltermodel.h"
#include "Model/sample/sample.h"
#include "fieldcolumninfos.h"

class ResultsTreeModel;
class RemoteSampleTreeModel;

class FilteringAnalysis : public Analysis
{
    Q_OBJECT

    // Analysis properties
    Q_PROPERTY(QString refName READ refName)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString filter READ filter WRITE setFilter NOTIFY filterUpdated)
    Q_PROPERTY(QStringList fields READ fields NOTIFY fieldsUpdated)
    Q_PROPERTY(int resultsTotal READ resultsTotal NOTIFY resultsTotalChanged)
    // Panel & Treeview models
    Q_PROPERTY(AnnotationsTreeModel* annotations READ annotations NOTIFY annotationsUpdated)
    Q_PROPERTY(AnnotationsTreeModel* allAnnotationsDB READ allAnnotationsDB NOTIFY allAnnotationsDBUpdated)
    Q_PROPERTY(ResultsTreeModel* results READ results NOTIFY resultsUpdated)
    Q_PROPERTY(QuickFilterModel* quickfilters READ quickfilters NOTIFY quickfiltersUpdated)
    Q_PROPERTY(RemoteSampleTreeModel* remoteSamples READ remoteSamples NOTIFY remoteSamplesUpdated)
    // "Shortcuts properties" for QML
    Q_PROPERTY(QStringList samples READ displayedSamples NOTIFY samplesUpdated)
    Q_PROPERTY(QStringList resultColumns READ resultColumns NOTIFY resultColumnsChanged)

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
    inline QString filter() { return mFilter; }
    inline QString refName() { return mRefName; }
    inline int refId() { return mRefId; }
    inline QString status() { return mStatus; }
    inline LoadingStatus loadingStatus() { return mLoadingStatus; }
    inline AnnotationsTreeModel* annotations() { return mAnnotationsTreeModel; }
    inline AnnotationsTreeModel* allAnnotationsDB() { return mAllAnnotationsTreeModel; }
    inline QStringList fields() { return mFields; }
    inline ResultsTreeModel* results() { return mResults; }
    inline QuickFilterModel* quickfilters() { return mQuickFilters; }
    inline RemoteSampleTreeModel* remoteSamples() { return mRemoteSampleTreeModel; }
    inline QList<Sample*> samples() { return mSamples; }
    inline int resultsTotal() { return mResultsTotal; }
    QStringList displayedSamples();
    QStringList resultColumns();

    // Setters
    Q_INVOKABLE inline void setFilter(QString filter) { mFilter = filter; emit filterUpdated(); }
    Q_INVOKABLE int setField(QString uid, bool isDisplayed, int order=-1);

    // Methods
    bool fromJson(QJsonObject json);
    Q_INVOKABLE inline FieldColumnInfos* getColumnInfo(QString uid) { return mAnnotations.contains(uid) ? mAnnotations[uid] : nullptr; }


Q_SIGNALS:
    void isLoading();
    void statusChanged();
    void loadingStatusChanged(LoadingStatus oldSatus, LoadingStatus newStatus);
    void annotationsUpdated();
    void allAnnotationsDBUpdated();
    void filterUpdated();
    void fieldsUpdated();
    void resultsUpdated();
    void quickfiltersUpdated();
    void remoteSamplesUpdated();
    void samplesUpdated();
    void sampleColumnDisplayedUpdated();
    void resultColumnsChanged();
    void resultsTotalChanged();


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

    QString mStatus; // status of the analysis (server side)
    LoadingStatus mLoadingStatus; // internal (UI) status used to track and coordinates asynchrone initialisation of the analysis
    ResultsTreeModel* mResults;
    QuickFilterModel* mQuickFilters;

    QHash<QString, FieldColumnInfos*> mAnnotations;
    AnnotationsTreeModel* mAllAnnotationsTreeModel;
    AnnotationsTreeModel* mAnnotationsTreeModel;
    RemoteSampleTreeModel* mRemoteSampleTreeModel;
    QList<FieldColumnInfos*> mDisplayedAnnotationColumns;

    bool mIsTrio;
    QStringList mAnnotationsDBUsed;
    int mTrioChild;
    int mTrioMother;
    int mTrioFather;
    int mResultsTotal;



    // Methods
    void loadAnnotations();
    void loadResults();
    void refreshDisplayedAnnotationColumns();
};

#endif // FILTERINGANALYSIS_H
