#ifndef FILTERINGANALYSIS_H
#define FILTERINGANALYSIS_H

#include <QObject>
#include "../analysis.h"
#include "resultstreemodel.h"
#include "annotationstreemodel.h"
#include "quickfilters/quickfiltermodel.h"
#include "Model/subject/sample.h"
#include "Model/subject/reference.h"
#include "Model/subject/attribute.h"
#include "fieldcolumninfos.h"
#include "savedfilter.h"
#include "advancedfilters/advancedfiltermodel.h"
#include "advancedfilters/set.h"

class AdvancedFilterModel;
class NewAdvancedFilterModel;
class Set;
class ResultsTreeModel;


class FilteringAnalysis : public Analysis
{
    Q_OBJECT

    // Analysis properties
    Q_PROPERTY(int refId READ refId NOTIFY refChanged)
    Q_PROPERTY(QString refName READ refName NOTIFY refChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(QJsonArray filterJson READ filterJson NOTIFY filterChanged)      // Filter json formated shared with server
    Q_PROPERTY(QStringList fields READ fields NOTIFY fieldsChanged)             // List of fields UID shared with Server to retrieve information about variant/trx
    Q_PROPERTY(int resultsTotal READ resultsTotal NOTIFY resultsTotalChanged)   // TODO : shall be results.total
    Q_PROPERTY(QList<QObject*> samples READ samples4qml NOTIFY samplesChanged)
    Q_PROPERTY(QList<QObject*> filters READ filters NOTIFY filtersChanged)
    Q_PROPERTY(QList<QObject*> attributes READ attributes NOTIFY attributesChanged)
    Q_PROPERTY(bool isTrio READ isTrio WRITE setIsTrio NOTIFY isTrioChanged)
    Q_PROPERTY(Sample* child READ trioChild WRITE setTrioChild NOTIFY trioChildChanged)
    Q_PROPERTY(Sample* mother READ trioMother WRITE setTrioMother NOTIFY trioMotherChanged)
    Q_PROPERTY(Sample* father READ trioFather WRITE setTrioFather NOTIFY trioFatherChanged)
    // Panel & Treeview models
    Q_PROPERTY(AnnotationsTreeModel* annotations READ annotations NOTIFY annotationsChanged)
    Q_PROPERTY(QList<QObject*> annotationsFlatList READ annotationsFlatList NOTIFY annotationsFlatListChanged)
    Q_PROPERTY(QList<QObject*> allAnnotations READ allAnnotations NOTIFY allAnnotationsChanged)
    Q_PROPERTY(ResultsTreeModel* results READ results NOTIFY resultsChanged)
    Q_PROPERTY(QuickFilterModel* quickfilters READ quickfilters NOTIFY filterChanged)
    Q_PROPERTY(AdvancedFilterModel* advancedfilter READ advancedfilter NOTIFY filterChanged)
    // New/Edit ConditionDialog
    Q_PROPERTY(NewAdvancedFilterModel* newConditionModel READ newConditionModel NOTIFY newConditionModelChanged)
    Q_PROPERTY(QList<QObject*> samplesInputsFilesList READ samplesInputsFilesList NOTIFY samplesInputsFilesListChanged)
    // "Shortcuts properties" for QML
    // Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(QStringList resultColumns READ resultColumns NOTIFY resultColumnsChanged)
    Q_PROPERTY(QStringList selectedAnnotationsDB READ selectedAnnotationsDB NOTIFY selectedAnnotationsDBChanged)
    Q_PROPERTY(QString currentFilterName READ currentFilterName WRITE setCurrentFilterName NOTIFY currentFilterNameChanged)
    Q_PROPERTY(QList<QObject*> sets READ sets NOTIFY setsChanged)




public:
    enum LoadingStatus
    {
        Empty,
        LoadingAnnotations,
        LoadingResults,
        Ready,
        Error
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
    inline QJsonArray filterJson() { return mFilterJson; }
    inline QStringList fields() { return mFields; }
    inline int resultsTotal() { return mResultsTotal; }
    inline QList<Sample*> samples() { return mSamples; }
    inline QList<QObject*> filters() { return mFilters; }
    inline QList<QObject*> attributes() { return mAttributes; }
    inline bool isTrio() const { return mIsTrio; }
    inline Sample* trioChild() const { return mTrioChild; }
    inline Sample* trioMother() const { return mTrioMother; }
    inline Sample* trioFather() const { return mTrioFather; }
    inline QList<QObject*> samplesInputsFilesList() const { return mSamplesInputsFilesList; }
    // Panel & Treeview models
    inline AnnotationsTreeModel* annotations() { return mAnnotationsTreeModel; }
    inline QList<QObject*> annotationsFlatList() { return mAnnotationsFlatList; }
    inline QList<QObject*> allAnnotations() { return mAllAnnotations; }
    inline ResultsTreeModel* results() { return mResults; }
    inline QuickFilterModel* quickfilters() { return mQuickFilters; }
    inline AdvancedFilterModel* advancedfilter() { return mAdvancedFilter; }
    inline NewAdvancedFilterModel* newConditionModel() { return mNewConditionModel; }
    // "Shortcuts properties" for QML
    QList<QObject*> samples4qml();      // convert QList<Sample*> to QList<QObject*>
    QStringList resultColumns();
    QStringList selectedAnnotationsDB();
    inline bool isLoading() const { return mIsLoading; }
    inline QString currentFilterName() const { return mCurrentFilterName; }
    QList<QObject*> sets() const { return mSets; } // concat filters, samples, samples attributes and panel in one list

    // Setters
    Q_INVOKABLE inline void setFilterJson(QJsonArray filterJson) { mFilterJson = filterJson; emit filterChanged(); }
    Q_INVOKABLE inline void setIsTrio(bool flag) { mIsTrio=flag; emit isTrioChanged(); }
    Q_INVOKABLE inline void setTrioChild(Sample* child) { mTrioChild=child; emit trioChildChanged(); }
    Q_INVOKABLE inline void setTrioMother(Sample* mother) { mTrioMother=mother; emit trioMotherChanged(); }
    Q_INVOKABLE inline void setTrioFather(Sample* father) { mTrioFather=father; emit trioFatherChanged(); }
    Q_INVOKABLE inline void setIsLoading(bool flag) { mIsLoading=flag; emit isLoadingChanged(); }
    Q_INVOKABLE inline void setCurrentFilterName(QString name) { mCurrentFilterName=name; emit currentFilterNameChanged(); }
    Q_INVOKABLE int setField(QString uid, bool isDisplayed, int order=-1);
    Q_INVOKABLE void setReference(Reference* ref, bool continueInit=false);

    // Methods
    bool fromJson(QJsonObject json);
    Q_INVOKABLE inline FieldColumnInfos* getColumnInfo(QString uid) { return mAnnotations.contains(uid) ? mAnnotations[uid] : nullptr; }
    Q_INVOKABLE inline void emitDisplayFilterSavingFormPopup() { emit displayFilterSavingFormPopup(); }
    Q_INVOKABLE inline void emitDisplayFilterNewCondPopup(QString conditionUid) { emit displayFilterNewCondPopup(conditionUid); }
    Q_INVOKABLE inline void emitSelectedAnnotationsDBChanged() { emit selectedAnnotationsDBChanged(); }
    Q_INVOKABLE inline void emitDisplayClearFilterPopup() { emit displayClearFilterPopup(); }
    Q_INVOKABLE void editFilter(int filterId, QString filterName, QString filterDescription, bool saveAdvancedFilter);
    Q_INVOKABLE void loadFilter(QString filter);
    Q_INVOKABLE void loadFilter(QJsonObject filter);
    Q_INVOKABLE void loadFilter(QJsonArray filter);
    Q_INVOKABLE void deleteFilter(int filterId);
    Q_INVOKABLE void saveAttribute(QString name, QStringList values);
    Q_INVOKABLE void deleteAttribute(QStringList names);
    Q_INVOKABLE SavedFilter* getSavedFilterById(int id);
    Q_INVOKABLE void addSamples(QList<QObject*> samples);
    Q_INVOKABLE void removeSamples(QList<QObject*> samples);
    Q_INVOKABLE void addSamplesFromFile(int fileId);
    Q_INVOKABLE void saveHeaderPosition(int oldPosition, int newPosition);
    Q_INVOKABLE void saveHeaderWidth(int headerPosition, double newSize);
    Q_INVOKABLE Set* getSetById(QString type, QString id);
    Q_INVOKABLE Sample* getSampleById(int id);
    Q_INVOKABLE void addSampleInputs(QList<QObject*> inputs);
    Q_INVOKABLE void removeSampleInputs(QList<QObject*> inputs);



    void raiseNewInternalLoadingStatus(LoadingStatus newStatus);
    void resetSets();

Q_SIGNALS:
    void isLoading();
    void statusChanged();
    void loadingStatusChanged(LoadingStatus oldSatus, LoadingStatus newStatus);
    void annotationsChanged();
    void annotationsFlatListChanged();
    void allAnnotationsChanged();
    void filterChanged();
    void fieldsChanged();
    void resultsChanged();
    void samplesChanged();
    void sampleColumnDisplayedUpdated();
    void resultColumnsChanged();
    void resultsTotalChanged();
    void displayFilterSavingFormPopup();
    void displayFilterNewCondPopup(QString conditionUid);
    void displayClearFilterPopup();
    void selectedAnnotationsDBChanged();
    void refChanged();
    void isTrioChanged();
    void trioChildChanged();
    void trioMotherChanged();
    void trioFatherChanged();
    void isLoadingChanged();
    void newConditionModelChanged();
    void samplesInputsFilesListChanged();
    void filtersChanged();
    void attributesChanged();
    void currentFilterNameChanged();
    void setsChanged();


public Q_SLOTS:
    //! method use to "chain" asynch request for the init of the analysis
    void asynchLoadingCoordination(LoadingStatus oldSatus, LoadingStatus newStatus);
    //! handle message received from server via websocket
    void onWebsocketMessageReceived(QString ,QJsonObject);

private:
    // Attributes
    int mRefId = -1;
    QString mRefName;
    QStringList mFields;
    QJsonArray mFilterJson;
    QList<Sample*> mSamples;
    QList<QObject*> mFilters;
    QList<QObject*> mAttributes;
    bool mSampleColumnDisplayed = false;

    QString mStatus; // status of the analysis (server side)
    LoadingStatus mLoadingStatus; // internal (UI) status used to track and coordinates asynchrone initialisation of the analysis
    ResultsTreeModel* mResults = nullptr;
    QuickFilterModel* mQuickFilters = nullptr;
    AdvancedFilterModel* mAdvancedFilter = nullptr;
    NewAdvancedFilterModel* mNewConditionModel = nullptr;
    QList<QObject*> mSamplesInputsFilesList;

    QHash<QString, FieldColumnInfos*> mAnnotations;
    QList<QObject*> mAnnotationsFlatList;
    QList<QObject*> mAllAnnotations;
    AnnotationsTreeModel* mAnnotationsTreeModel = nullptr;
    QList<FieldColumnInfos*> mDisplayedAnnotationColumns;
    int mQtBugQMLHeaderDelegatePressedEventCalledTwiceWorkaround = 0;

    bool mIsTrio = false;
    QStringList mAnnotationsDBUsed;
    Sample* mTrioChild = nullptr;
    Sample* mTrioMother = nullptr;
    Sample* mTrioFather = nullptr;
    int mResultsTotal = 0;
    QList<int> mSamplesIds; // = mSamples, but use as shortcuts to check quickly by sample id
    bool mIsLoading = false;
    QString mCurrentFilterName;
    QList<QObject*> mSets;


    // Methods
    void loadAnnotations();
    void initResults();
    void refreshDisplayedAnnotationColumns();
    void saveSettings();
    void loadSettings();
};

#endif // FILTERINGANALYSIS_H
