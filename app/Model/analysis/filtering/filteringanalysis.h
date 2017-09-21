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
#include "reference.h"

class ResultsTreeModel;
class RemoteSampleTreeModel;

class FilteringAnalysis : public Analysis
{
    Q_OBJECT

    // Analysis properties
    Q_PROPERTY(int refId READ refId NOTIFY refChanged)
    Q_PROPERTY(QString refName READ refName NOTIFY refChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString filter READ filter WRITE setFilter NOTIFY filterChanged)
    Q_PROPERTY(QJsonArray filterJson READ filterJson NOTIFY filterJsonChanged)
    Q_PROPERTY(QStringList fields READ fields NOTIFY fieldsChanged)
    Q_PROPERTY(int resultsTotal READ resultsTotal NOTIFY resultsTotalChanged)
    Q_PROPERTY(QVariantList filters READ filters NOTIFY filtersChanged)
    Q_PROPERTY(QList<QObject*> samples READ samples4qml NOTIFY samplesChanged)
    Q_PROPERTY(bool isTrio READ isTrio WRITE setIsTrio NOTIFY isTrioChanged)
    Q_PROPERTY(Sample* child READ trioChild WRITE setTrioChild NOTIFY trioChildChanged)
    Q_PROPERTY(Sample* mother READ trioMother WRITE setTrioMother NOTIFY trioMotherChanged)
    Q_PROPERTY(Sample* father READ trioFather WRITE setTrioFather NOTIFY trioFatherChanged)
    // Panel & Treeview models
    Q_PROPERTY(AnnotationsTreeModel* annotations READ annotations NOTIFY annotationsChanged)
    Q_PROPERTY(QList<QObject*> allAnnotations READ allAnnotations NOTIFY allAnnotationsChanged)
    Q_PROPERTY(ResultsTreeModel* results READ results NOTIFY resultsChanged)
    Q_PROPERTY(QuickFilterModel* quickfilters READ quickfilters NOTIFY quickfiltersChanged)
    //Q_PROPERTY(RemoteSampleTreeModel* remoteSamples READ remoteSamples NOTIFY remoteSamplesChanged)
    // "Shortcuts properties" for QML
    Q_PROPERTY(QStringList resultColumns READ resultColumns NOTIFY resultColumnsChanged)
    Q_PROPERTY(QStringList selectedAnnotationsDB READ selectedAnnotationsDB NOTIFY selectedAnnotationsDBChanged)




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
    explicit FilteringAnalysis(QObject* parent = nullptr);

    // Getters
    // Internal
    inline int refId() { return mRefId; }
    inline LoadingStatus loadingStatus() { return mLoadingStatus; }
    // Analysis properties
    inline QString refName() { return mRefName; }
    inline QString status() { return mStatus; }
    inline QString filter() { return mFilter; }
    inline QJsonArray filterJson() { return mFilterJson; }
    inline QStringList fields() { return mFields; }
    inline int resultsTotal() { return mResultsTotal; }
    inline QVariantList filters() { return mFilters; }
    inline QList<Sample*> samples() { return mSamples; }
    inline bool isTrio() const { return mIsTrio; }
    inline Sample* trioChild() const { return mTrioChild; }
    inline Sample* trioMother() const { return mTrioMother; }
    inline Sample* trioFather() const { return mTrioFather; }
    // Panel & Treeview models
    inline AnnotationsTreeModel* annotations() { return mAnnotationsTreeModel; }
    inline QList<QObject*> allAnnotations() { return mAllAnnotations; }
    inline ResultsTreeModel* results() { return mResults; }
    inline QuickFilterModel* quickfilters() { return mQuickFilters; }
    inline RemoteSampleTreeModel* remoteSamples() { return mRemoteSampleTreeModel; }
    // "Shortcuts properties" for QML
    QList<QObject*> samples4qml();
    QStringList resultColumns();
    QStringList selectedAnnotationsDB();

    // Setters
    Q_INVOKABLE inline void setFilter(QString filter) { mFilter = filter; emit filterChanged(); }
    Q_INVOKABLE inline void setFilterJson(QJsonArray filterJson) { mFilterJson = filterJson; emit filterJsonChanged(); }
    Q_INVOKABLE int setField(QString uid, bool isDisplayed, int order=-1);
    Q_INVOKABLE void setReference(Reference* ref, bool continueInit=false);
    Q_INVOKABLE void setIsTrio(bool flag) { mIsTrio=flag; emit isTrioChanged(); }
    Q_INVOKABLE void setTrioChild(Sample* child) { mTrioChild=child; emit trioChildChanged(); }
    Q_INVOKABLE void setTrioMother(Sample* mother) { mTrioMother=mother; emit trioMotherChanged(); }
    Q_INVOKABLE void setTrioFather(Sample* father) { mTrioFather=father; emit trioFatherChanged(); }

    // Methods
    bool fromJson(QJsonObject json);
    Q_INVOKABLE inline FieldColumnInfos* getColumnInfo(QString uid) { return mAnnotations.contains(uid) ? mAnnotations[uid] : nullptr; }
    Q_INVOKABLE void getVariantInfo(QString variantId);
    Q_INVOKABLE inline void emitDisplayFilterSavingFormPopup() { emit displayFilterSavingFormPopup(); }
    Q_INVOKABLE inline void emitDisplayFilterNewCondPopup(QJsonArray filter) { emit displayFilterNewCondPopup(); }
    Q_INVOKABLE inline void emitSelectedAnnotationsDBChanged() { emit selectedAnnotationsDBChanged(); }
    Q_INVOKABLE void saveCurrentFilter(QString filterName, QString filterDescription);
    Q_INVOKABLE void loadFilter(QJsonObject filter);
    Q_INVOKABLE void loadFilter(QString filter);
    Q_INVOKABLE void addSamples(QList<QObject*> samples);
    Q_INVOKABLE void removeSamples(QList<QObject*> samples);


Q_SIGNALS:
    void isLoading();
    void statusChanged();
    void loadingStatusChanged(LoadingStatus oldSatus, LoadingStatus newStatus);
    void annotationsChanged();
    void allAnnotationsChanged();
    void filterChanged();
    void filterJsonChanged();
    void filtersChanged();
    void fieldsChanged();
    void resultsChanged();
    void quickfiltersChanged();
    void remoteSamplesChanged();
    void samplesChanged();
    void sampleColumnDisplayedUpdated();
    void resultColumnsChanged();
    void resultsTotalChanged();
    void onContextualVariantInformationReady(QJsonObject json);
    void displayFilterSavingFormPopup();
    void displayFilterNewCondPopup();
    void selectedAnnotationsDBChanged();
    void refChanged();
    void isTrioChanged();
    void trioChildChanged();
    void trioMotherChanged();
    void trioFatherChanged();

public Q_SLOTS:
    //! method use to "chain" asynch request for the init of the analysis
    void asynchLoadingCoordination(LoadingStatus oldSatus, LoadingStatus newStatus);


private:
    // Attributes
    int mRefId;
    QString mRefName;
    QStringList mFields;
    QString mFilter;
    QJsonArray mFilterJson;
    QList<Sample*> mSamples;
    bool mSampleColumnDisplayed;

    QString mStatus; // status of the analysis (server side)
    LoadingStatus mLoadingStatus; // internal (UI) status used to track and coordinates asynchrone initialisation of the analysis
    ResultsTreeModel* mResults;
    QuickFilterModel* mQuickFilters;

    QHash<QString, FieldColumnInfos*> mAnnotations;
    QList<QObject*> mAllAnnotations;
    AnnotationsTreeModel* mAnnotationsTreeModel;
    RemoteSampleTreeModel* mRemoteSampleTreeModel;
    QList<FieldColumnInfos*> mDisplayedAnnotationColumns;

    bool mIsTrio;
    QStringList mAnnotationsDBUsed;
    Sample* mTrioChild;
    Sample* mTrioMother;
    Sample* mTrioFather;
    int mResultsTotal;
    QVariantList mFilters;
    QList<int> mSamplesIds; // = mSamples, but use as shortcuts to check quickly by sample id


    // Methods
    void loadAnnotations();
    void loadResults();
    void refreshDisplayedAnnotationColumns();


};

#endif // FILTERINGANALYSIS_H
