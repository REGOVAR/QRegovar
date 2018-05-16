#ifndef FILTERINGANALYSIS_H
#define FILTERINGANALYSIS_H

#include <QObject>
#include "Model/project/project.h"
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
#include "documentstreemodel.h"
#include "Model/event/eventslistmodel.h"

class AdvancedFilterModel;
class NewAdvancedFilterModel;
class Set;
class ResultsTreeModel;
class DocumentsTreeModel;
class AnnotationsTreeModel;

class FilteringAnalysis : public Analysis
{
    Q_OBJECT
    // Analysis properties
    Q_PROPERTY(int refId READ refId NOTIFY dataChanged)
    Q_PROPERTY(QString refName READ refName NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject stats READ stats NOTIFY dataChanged)
    Q_PROPERTY(EventsListModel* events READ events NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject computingProgress READ computingProgress NOTIFY statusChanged)
    // Filtering properties
    Q_PROPERTY(QJsonArray filterJson READ filterJson NOTIFY filterChanged)      // Filter json formated shared with server
    Q_PROPERTY(QStringList order READ order NOTIFY orderChanged)                // List of field used for sorting result
    Q_PROPERTY(QList<QObject*> samples READ samples4qml NOTIFY samplesChanged)
    Q_PROPERTY(QList<QObject*> filters READ filters NOTIFY filtersChanged)
    Q_PROPERTY(QList<QObject*> attributes READ attributes NOTIFY attributesChanged)
    Q_PROPERTY(bool isTrio READ isTrio WRITE setIsTrio NOTIFY isTrioChanged)
    Q_PROPERTY(Sample* child READ trioChild WRITE setTrioChild NOTIFY trioChildChanged)
    Q_PROPERTY(Sample* mother READ trioMother WRITE setTrioMother NOTIFY trioMotherChanged)
    Q_PROPERTY(Sample* father READ trioFather WRITE setTrioFather NOTIFY trioFatherChanged)
    // Panel & Treeview models
    Q_PROPERTY(AnnotationsTreeModel* annotationsTree READ annotationsTree NOTIFY annotationsChanged)
    Q_PROPERTY(QList<QObject*> annotationsFlatList READ annotationsFlatList NOTIFY annotationsChanged)
    Q_PROPERTY(QList<QObject*> allAnnotations READ allAnnotations NOTIFY annotationsChanged)
    Q_PROPERTY(QList<QObject*> displayedAnnotations READ displayedAnnotations NOTIFY displayedAnnotationsChanged)
    Q_PROPERTY(int samplesByRow READ samplesByRow NOTIFY displayedAnnotationsChanged)
    Q_PROPERTY(ResultsTreeModel* results READ results NOTIFY resultsChanged)
    Q_PROPERTY(QuickFilterModel* quickfilters READ quickfilters NOTIFY filterChanged)
    Q_PROPERTY(AdvancedFilterModel* advancedfilter READ advancedfilter NOTIFY filterChanged)
    Q_PROPERTY(DocumentsTreeModel* documents READ documents NOTIFY documentsChanged)
    // New/Edit ConditionDialog
    Q_PROPERTY(NewAdvancedFilterModel* newConditionModel READ newConditionModel NOTIFY newConditionModelChanged)
    Q_PROPERTY(QList<QObject*> samplesInputsFilesList READ samplesInputsFilesList NOTIFY samplesInputsFilesListChanged)
    // "Shortcuts properties" for QML
    Q_PROPERTY(bool loading READ loading WRITE setLoading NOTIFY loadingChanged)

    Q_PROPERTY(QStringList selectedAnnotationsDB READ selectedAnnotationsDB NOTIFY dataChanged)
    Q_PROPERTY(QStringList panelsUsed READ panelsUsed NOTIFY panelsUsedChanged)
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
    explicit FilteringAnalysis(int id, QObject* parent = nullptr);

    // Getters
    inline QString refName() const { return mRefName; }
    inline QJsonArray filterJson() const { return mFilterJson; }
    inline QStringList fields() const { return mFields; }
    inline QStringList order() const { return mOrder; }
    inline int refId() const { return mRefId; }
    inline QList<Sample*> samples() const { return mSamples; }
    inline QList<QObject*> filters() const { return mFilters; }
    inline QList<QObject*> attributes() const { return mAttributes; }
    inline bool isTrio() const { return mIsTrio; }
    inline Sample* trioChild() const { return mTrioChild; }
    inline Sample* trioMother() const { return mTrioMother; }
    inline Sample* trioFather() const { return mTrioFather; }
    inline QList<QObject*> samplesInputsFilesList() const { return mSamplesInputsFilesList; }
    inline QJsonObject stats() const { return mStats; }
    inline EventsListModel* events() const { return mEvents; }
    inline QJsonObject computingProgress() const { return mComputingProgress; }
    // Panel & Treeview models
    inline QHash<QString, FieldColumnInfos*> annotationsMap() { return mAnnotations; }
    inline AnnotationsTreeModel* annotationsTree() const { return mAnnotationsTreeModel; }
    inline QList<QObject*> annotationsFlatList() const { return mAnnotationsFlatList; }
    inline QList<QObject*> allAnnotations() const { return mAllAnnotations; }
    inline ResultsTreeModel* results() const { return mResults; }
    inline DocumentsTreeModel* documents() const { return mDocumentsTreeModel; }
    inline QuickFilterModel* quickfilters() const { return mQuickFilters; }
    inline AdvancedFilterModel* advancedfilter() const { return mAdvancedFilter; }
    inline NewAdvancedFilterModel* newConditionModel() const { return mNewConditionModel; }
    // "Shortcuts properties" for QML
    QList<QObject*> samples4qml();      // convert QList<Sample*> to QList<QObject*>
    inline QList<QObject*> displayedAnnotations() const { return mDisplayedAnnotations; }
    inline int samplesByRow() const { return mSamplesByRow; }
    QStringList selectedAnnotationsDB();
    inline QStringList panelsUsed() const { return mPanelsUsed; }
    inline bool loading() const { return mLoading; }
    inline QString currentFilterName() const { return mCurrentFilterName; }
    QList<QObject*> sets() const { return mSets; } // concat filters, samples, samples attributes and panel in one list

    // Setters
    inline void setFilterJson(QJsonArray filterJson) { mFilterJson = filterJson; emit filterChanged(); }
    inline void setIsTrio(bool flag) { mIsTrio=flag; emit isTrioChanged(); }
    inline void setTrioChild(Sample* child) { mTrioChild=child; emit trioChildChanged(); }
    inline void setTrioMother(Sample* mother) { mTrioMother=mother; emit trioMotherChanged(); }
    inline void setTrioFather(Sample* father) { mTrioFather=father; emit trioFatherChanged(); }
    inline void setLoading(bool flag) { mLoading=flag; emit loadingChanged(); }
    inline void setCurrentFilterName(QString name) { mCurrentFilterName=name; emit currentFilterNameChanged(); }
    void setReference(Reference* ref, bool continueInit=false);


    // Analysis abstracts methods overriden
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true);
    Q_INVOKABLE QJsonObject toJson();
    Q_INVOKABLE void save();
    Q_INVOKABLE void load(bool forceRefresh=true);

    // Methods
    Q_INVOKABLE inline FieldColumnInfos* getColumnInfo(QString uid) { return mAnnotations.contains(uid) ? mAnnotations[uid] : nullptr; }
    Q_INVOKABLE inline void emitDisplayFilterSavingFormPopup() { emit displayFilterSavingFormPopup(); }
    Q_INVOKABLE inline void emitDisplayFilterNewCondPopup(QString conditionUid) { emit displayFilterNewCondPopup(conditionUid); }
    Q_INVOKABLE inline void emitDisplayClearFilterPopup() { emit displayClearFilterPopup(); }
    Q_INVOKABLE void editFilter(int filterId, QString filterName, QString filterDescription, bool saveAdvancedFilter);
    Q_INVOKABLE void loadFilter(QString filter);
    Q_INVOKABLE void loadFilter(QJsonObject filter);
    Q_INVOKABLE void loadFilter(QJsonArray filter);
    Q_INVOKABLE void setFilterOrder(int column, bool order);
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
    Q_INVOKABLE void setVariantSelection(QString id, bool isChecked);
    Q_INVOKABLE void addFile(File* file);
    Q_INVOKABLE void applyChangeForDisplayedAnnotations();
    Q_INVOKABLE void setDisplayedAnnotationTemp(QString uid, bool check);
    Q_INVOKABLE void reopen();


    void raiseNewInternalLoadingStatus(LoadingStatus newStatus);
    void resetSets();

Q_SIGNALS:
    void dataChanged();

    void loadingStatusChanged(LoadingStatus oldSatus, LoadingStatus newStatus);
    void annotationsChanged();
    void displayedAnnotationsChanged();
    void filterChanged();
    //void fieldsChanged();
    void resultsChanged();
    void samplesChanged();
    void orderChanged();
    void displayFilterSavingFormPopup();
    void displayFilterNewCondPopup(QString conditionUid);
    void displayClearFilterPopup();
    void isTrioChanged();
    void trioChildChanged();
    void trioMotherChanged();
    void trioFatherChanged();
    void loadingChanged();
    void newConditionModelChanged();
    void samplesInputsFilesListChanged();
    void filtersChanged();
    void attributesChanged();
    void currentFilterNameChanged();
    void setsChanged();
    void fileAdded(int fileId);
    void documentsChanged();
    void panelsUsedChanged();
    void loaded();



public Q_SLOTS:
    //! method use to "chain" asynch request for the init of the analysis
    void asynchLoadingCoordination(LoadingStatus oldSatus, LoadingStatus newStatus);
    //! handle message received from server via websocket
    void processPushNotification(QString action, QJsonObject data);

private:
    int mRefId = -1;
    QString mRefName;
    QStringList mFields;
    QStringList mOrder;
    QJsonArray mFilterJson;
    QList<Sample*> mSamples;
    QList<QObject*> mFilters;
    QList<QObject*> mAttributes;
    QList<File*> mFiles;
    DocumentsTreeModel* mDocumentsTreeModel = nullptr;
    QJsonObject mStats;
    EventsListModel* mEvents = nullptr;
    QJsonObject mComputingProgress;

    LoadingStatus mLoadingStatus; // internal (UI) status used to track and coordinates asynchrone initialisation of the analysis
    ResultsTreeModel* mResults = nullptr;
    QuickFilterModel* mQuickFilters = nullptr;
    AdvancedFilterModel* mAdvancedFilter = nullptr;
    NewAdvancedFilterModel* mNewConditionModel = nullptr;
    QList<QObject*> mSamplesInputsFilesList;

    /// List<AnnotationDB*>: List of all annotation databases available for the reference used for this analysis. Init when reference is set.
    QList<QObject*> mAllAnnotations;
    /// Map with all UI information by annotations needed by the VariantTable to display annotation's columns
    QHash<QString, FieldColumnInfos*> mAnnotations;
    /// List<Annotation*>: one dimension list with all annotations available (use by UI in dropdown list form when need to select annotation condition by example)
    QList<QObject*> mAnnotationsFlatList;
    /// Treeview model used by UI to display the "Select Annotation's panel in the filtering view"
    AnnotationsTreeModel* mAnnotationsTreeModel = nullptr;
    /// QList<FieldColumnInfos*>: ordered list of columns displayed in the VariantTable. Contains Annotation column but also pure UI column like RowHead and SampleName
    QList<QObject*> mDisplayedAnnotations;
    /// Indicates how many sample shall be displayed by row in the UI TableVariant
    int mSamplesByRow;



    bool mIsTrio = false;
    QStringList mAnnotationsDBUsed;
    QStringList mPanelsUsed;
    Sample* mTrioChild = nullptr;
    Sample* mTrioMother = nullptr;
    Sample* mTrioFather = nullptr;
    QList<int> mSamplesIds; // = mSamples, but use as shortcuts to check quickly by sample id
    bool mLoading = false;
    QString mCurrentFilterName;
    QList<QObject*> mSets;


    // Methods
    void loadAnnotations();
    void initResults();
    void initDisplayedAnnotations();
    void saveSettings();
    void loadSettings();


    // Others
    int mQtBugWorkaround_QMLHeaderDelegatePressedEventCalledTwice = 0;
};

#endif // FILTERINGANALYSIS_H
