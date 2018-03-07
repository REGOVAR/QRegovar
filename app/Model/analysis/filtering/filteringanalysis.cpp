#include "filteringanalysis.h"

#include "Model/framework/request.h"
#include "Model/regovar.h"
#include "annotation.h"

FilteringAnalysis::FilteringAnalysis(QObject *parent) : Analysis(parent)
{
    // Tree model are created to allow QML binding initialisation even if no data loaded
    mType = AnalysesManager::FILTERING;
    mResults = new ResultsTreeModel(this);
    mAnnotationsTreeModel = new AnnotationsTreeModel(this);
    mQuickFilters = new QuickFilterModel(this);
    mAdvancedFilter = new AdvancedFilterModel(this);
    mNewConditionModel = new NewAdvancedFilterModel(this);
    mDocumentsTreeModel = new DocumentsTreeModel(this);
    mMenuModel->initFilteringAnalysis();
    mLoadingStatus = Empty;


    connect(this, SIGNAL(loadingStatusChanged(LoadingStatus,LoadingStatus)),
            this, SLOT(asynchLoadingCoordination(LoadingStatus,LoadingStatus)));


    // Init model
    setLoading(true);
}


FilteringAnalysis::FilteringAnalysis(int id, QObject* parent) : FilteringAnalysis(parent)
{
    // Notice : -1 is for unvalid analysis, >0 is for existing analyses in Regovar srver DB, 0 is for new wizard model
    mId = id;
}





//
// Analysis Abstracty Methods overriden ----------------------------------------------------------------------------------
//




bool FilteringAnalysis::fromJson(QJsonObject json, bool full_init)
{
    // load basic data from json
    setId(json["id"].toInt());
    setName(json["name"].toString());
    setComment(json["comment"].toString());
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);
    mStatus = json["status"].toString();
    mComputingProgress = json["computing_progress"].toObject();
    mStats = json["statistics"].toObject();

    // Getting ref
    Reference* ref = regovar->referenceFromId(json["reference_id"].toInt());
    if (ref == nullptr)
    {
        // Abord init. This kind of init occure when just displaying list of lastest analyses.
        // We do not load all data of analyses...
        return false;
    }


    if (!full_init) return true;

    // Get events
    if (mId > 0)
    {
        mEvents = new EventsListModel("analysis_id", QString::number(mId));
    }

    // Parse settings
    QJsonObject settings = json["settings"].toObject();
    for (const QJsonValue& field: settings["annotations_db"].toArray())
    {
        mAnnotationsDBUsed << field.toString();
    }
    for (const QJsonValue& field: settings["panels"].toArray())
    {
        mPanelsUsed << field.toString();
    }

    // Retrieve samples
    mSamples.clear();
    for (const QJsonValue& spJson: json["samples"].toArray())
    {
        QJsonObject sampleData = spJson.toObject();
        Sample* sample = regovar->samplesManager()->getOrCreateSample(sampleData["id"].toInt());
        if(sample->fromJson(sampleData))
        {
            mSamples.append(sample);
        }
    }

    if (settings["trio"].isBool())
    {
        mIsTrio = false;
    }
    else
    {
        QJsonObject trio = settings["trio"].toObject();
        mIsTrio = true;
        mTrioChild = regovar->samplesManager()->getOrCreateSample(trio["child_id"].toInt());
        mTrioMother = regovar->samplesManager()->getOrCreateSample(trio["mother_id"].toInt());
        mTrioFather = regovar->samplesManager()->getOrCreateSample(trio["father_id"].toInt());
        mTrioChild->setIsIndex(trio["child_index"].toBool());
        mTrioMother->setIsIndex(trio["mother_index"].toBool());
        mTrioFather->setIsIndex(trio["father_index"].toBool());
        if (full_init)
        {
            mSamples.move(mSamples.indexOf(mTrioChild), 0);
            mSamples.move(mSamples.indexOf(mTrioMother), 1);
        }
    }

    // Retrieve saved filters
    mFilters.clear();
    for (const QJsonValue& filterdata: json["filters"].toArray())
    {
        mFilters.append(new SavedFilter(filterdata.toObject()));
    }

    // Retrieve samples attributes
    mAttributes.clear();
    for (const QJsonValue& attributedata: json["attributes"].toArray())
    {
        mAttributes.append(new Attribute(attributedata.toObject()));
    }

    // Retrieve fields
    for (const QJsonValue& field: json["fields"].toArray())
    {
        mFields << field.toString();
    }

    // Retrieve order
    for (const QJsonValue& field: json["order"].toArray())
    {
        mOrder << field.toString();
    }

    // Once samples, attributes, filters and panels have been retrieved, create unique list of sets
    resetSets();

    // Retrieve results files
    mDocumentsTreeModel->refresh(json);


    // Loading of an analysis required several asynch steps
    // 1 : need to retrieve all complient annotations DB (need it when creating new analysis)
    // 2 : next init model with all available annotation's fields and setup GUI model to display only selected annotations
    // 3 : prepare quick filter (they need to check that they are complient with available annotations
    // 4 : set filter with the last applied filter
    // 5 : load results
    // Chaining of loading step is done thanks to signals (see asynchLoading slot)

    // The "true" loading of the filter must be done only after that annotation* information have been loaded
    // so for the init, we just save json filter, without loading/signal
    mFilterJson = json["filter"].toArray();

    // Set the ref and start (if needed) the next asynch loading step
    setReference(ref, full_init);

    mLoaded = true;
    emit samplesChanged();
    emit filtersChanged();
    emit attributesChanged();
    emit dataChanged();
    emit loaded();
    return true;
}




QJsonObject FilteringAnalysis::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("name", mName);
    result.insert("comment", mComment);
    // TODO: Indicators

    return result;
}

void FilteringAnalysis::save()
{
    if (mId <= 0) return;
    Request* request = Request::put(QString("/analysis/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Filtering Analysis saved";
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        request->deleteLater();
    });
}

void FilteringAnalysis::load(bool forceRefresh)
{
    if (mId <= 0) return;

    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (!mLoaded || forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();

        Request* req = Request::get(QString("/analysis/%1").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                fromJson(json["data"].toObject());
            }
            else
            {
                QJsonObject jsonError = json;
                jsonError.insert("method", Q_FUNC_INFO);
                regovar->raiseError(jsonError);
            }
            req->deleteLater();
        });
    }
}


//
// Init Async ----------------------------------------------------------------------------------
//





//! Set the reference for the analysis, and load all available annotations available for this ref (async)
void FilteringAnalysis::setReference(Reference* ref, bool continueInit)
{
    if (ref->id() == mRefId) return;


    // Set current ref
    mRefId = ref->id();
    mRefName = ref->name();

    // Update quickfilter
    mQuickFilters->init(ref->id(), mId);

    if (!continueInit) return;

    // STEP 1 : Load all available complient annotations DB
    qDebug() << QTime::currentTime().toString() << "REQUEST annotations : SEND";
    Request* req = Request::get(QString("/annotation/%1").arg(mRefId));
    connect(req, &Request::responseReceived, [this, req, continueInit](bool success, const QJsonObject& json)
    {
        qDebug() << QTime::currentTime().toString() << "REQUEST annotations : RECEIVED";
        mAllAnnotations.clear();
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            for (const QJsonValue& dbjson: data["db"].toArray())
            {
                QJsonObject db = dbjson.toObject();
                QString name = db["name"].toString();
                QString desc = db["description"].toString();
                QString duid = db["default"].toString();
                QJsonObject djsn = db["versions"].toObject();
                for (const QString& dbuid: djsn.keys())
                {
                    QJsonObject dbv = djsn[dbuid].toObject();
                    QString version = dbv["version"].toString();
                    QJsonArray fields = dbv["fields"].toArray();
                    bool isHeadVersion = duid == dbv["uid"].toString();
                    AnnotationDB* adb = new AnnotationDB(dbuid, name, desc, version, isHeadVersion, fields, this);
                    mAllAnnotations.append(adb);
                }
            }
            qDebug() << QTime::currentTime().toString() << "REQUEST annotations : DONE";
            // Annotations ready
            emit annotationsChanged();
            emit dataChanged();

            // continue by loading annotation's fields of selected DB
            raiseNewInternalLoadingStatus(LoadingAnnotations);
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
            raiseNewInternalLoadingStatus(Error);
        }
        req->deleteLater();
    });
}






void FilteringAnalysis::asynchLoadingCoordination(LoadingStatus oldSatus, LoadingStatus newStatus)
{
    // Full init not available for unvalid and new Wizard models
    if (mId <=0) return;

    if (newStatus == LoadingAnnotations)
    {
        loadAnnotations();
    }
    else if (newStatus == LoadingResults)
    {
        // Restore client settings (like columns pos/size)
        loadSettings();
        initResults();
    }
    else
    {
        qDebug() << "Filtering analysis" << oldSatus << "->" << newStatus;
    }
}




void FilteringAnalysis::loadAnnotations()
{
    qDebug() << QTime::currentTime().toString() << "LOAD annotations : step 1";

    // Init list of displayed columns according to analysis settings
    mResults->setIsLoading(true);
    mAnnotations.clear();
    mAnnotationsFlatList.clear();
    mAnnotations.insert("_RowHead", new FieldColumnInfos(nullptr, true, "", this));
    mAnnotations.insert("_Samples", new FieldColumnInfos(nullptr, false, "", this));
    mAnnotations["_RowHead"]->setUIUid("_RowHead");
    mAnnotations["_Samples"]->setUIUid("_Samples");

    // Update annotations databases
    mAnnotationsTreeModel->clear();
    for (QObject* o: mAllAnnotations)
    {
        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
        if (mAnnotationsDBUsed.contains(db->uid()) || db->isMandatory())
        {
            db->setSelected(true);
            for (Annotation* annot: db->fields())
            {
                QString uid = annot->uid();
                FieldColumnInfos* fInfo = new FieldColumnInfos(annot, mFields.contains(uid), "", this);
                mAnnotations.insert(uid, fInfo);
                mAnnotationsFlatList.append(annot);

                // add annotation to the treeModel of annotation available for this analysis
                mAnnotationsTreeModel->addEntry(db->name(), db->version(), db->description(), true, fInfo);
            }
        }
        else
        {
            db->setSelected(false);
        }
    }

    // prepare quick filter (they need to check that they are complient with available annotations
    qDebug() << QTime::currentTime().toString() << "LOAD annotations : step 2";
    mQuickFilters->checkAnnotationsDB(mAllAnnotations);

//    // set filter with the last applied filter
//    qDebug() << QTime::currentTime().toString() << "LOAD annotations : step 3";
//    loadFilter(mFilterJson);

//    // Init columns displayed in the results table
//    qDebug() << QTime::currentTime().toString() << "LOAD annotations : step 4";
//    initDisplayedAnnotations();

    // Load results(asynch)
    qDebug() << QTime::currentTime().toString() << "LOAD annotations : DONE";
    raiseNewInternalLoadingStatus(LoadingResults);
}

/// Set list of displayed columns
void FilteringAnalysis::initDisplayedAnnotations()
{
    qDebug() << QTime::currentTime().toString() << "LOAD QML Displayed columns : Step 1";
    // Reset all
    mDisplayedAnnotations.clear();
    mDisplayedAnnotations.append(mAnnotations["_RowHead"]);
    for (FieldColumnInfos* info: mAnnotations.values())
    {
        if (info) info->setIsDisplayed(false);
    }
    mAnnotations["_RowHead"]->setIsDisplayed(true);
    mSamplesByRow = 1;


    // Set which annotation are displayed respecting order. Add if needed special UI column like sample's name list
    qDebug() << QTime::currentTime().toString() << "LOAD QML Displayed columns : Step 2";
    for (const QString& uid: mFields)
    {
        if (mAnnotations.contains(uid))
        {
            if (mAnnotations[uid]->annotation()->type() == "sample_array" && !mAnnotations["_Samples"]->isDisplayed())
            {
                mAnnotations["_Samples"]->setIsDisplayed(true);
                mDisplayedAnnotations.append(mAnnotations["_Samples"]);
                mSamplesByRow = mSamples.count();
            }
            mDisplayedAnnotations.append(mAnnotations[uid]);
            mAnnotations[uid]->setIsDisplayed(true);
        }
    }
    qDebug() << QTime::currentTime().toString() << "LOAD QML Displayed columns : DONE -> notify QML to refresh table columns";
    emit displayedAnnotationsChanged();
}

/// Apply pending changes regarding which annotations are displayed in the UI and reload results TreeView
void FilteringAnalysis::applyChangeForDisplayedAnnotations()
{
    mResults->setIsLoading(true);
    bool needSamplesColumn = false;

    // loop over all annotations to check which ones need to be displayed or hiden
    for (FieldColumnInfos* info: mAnnotations.values())
    {
        if (info == nullptr) continue;
        if (!info->isDisplayedTemp() && mDisplayedAnnotations.contains(info))
        {
            mDisplayedAnnotations.removeAll(info);
            mFields.removeAll(info->uid());
            info->setIsDisplayed(false);
        }
        else if (info->isDisplayedTemp())
        {
            if (info->isAnnotation() && info->annotation()->type() == "sample_array")
            {
                needSamplesColumn = true;
            }
            if (!mDisplayedAnnotations.contains(info))
            {
                mDisplayedAnnotations << info;
                mFields.append(info->uid());
                info->setIsDisplayed(true);
            }
        }
    }

    // Add or remove UI Samples names columns according to annotations
    if (needSamplesColumn)
    {
        if (!mDisplayedAnnotations.contains(mAnnotations["_Samples"]))
        {
            for (int idx=0; idx<mDisplayedAnnotations.count(); idx++)
            {
                mDisplayedAnnotations.insert(idx, mAnnotations["_Samples"]);
                break;
            }
        }
        mAnnotations["_Samples"]->setIsDisplayed(true);
        mSamplesByRow = mSamples.count();
    }
    else
    {
        mAnnotations["_Samples"]->setIsDisplayed(false);
        mDisplayedAnnotations.removeAll(mAnnotations["_Samples"]);
        mSamplesByRow = 1;
    }



    // save columns settings on the local computer
    saveSettings();
    emit displayedAnnotationsChanged();

    // Force Variant table to refresh
    mResults->applyFilter(mFilterJson);
}

void FilteringAnalysis::setDisplayedAnnotationTemp(QString uid, bool check)
{
    if (mAnnotations.contains(uid))
    {
        mAnnotations[uid]->setIsDisplayedTemp(check);
    }
}




QList<QObject*> FilteringAnalysis::samples4qml()
{
    QList<QObject*> result;
    for (Sample* sp: mSamples)
    {
        QObject* obj = qobject_cast<QObject*>(sp);
        result << obj;
    }
    return result;
}


QStringList FilteringAnalysis::selectedAnnotationsDB()
{
    QStringList list;
    for (QObject* o: mAllAnnotations)
    {
        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
        if (db->selected())
        {
            QString name = db->name();
            if (db->version() != "")
            {
                name += " (" + db->version() + ")";
            }
            list << name;
        }
    }
    return list;
}




void FilteringAnalysis::initResults()
{
    qDebug() << QTime::currentTime().toString() << "INIT Result : Step 1";
    mResults->initAnalysisData(mId);
    mResults->applyFilter(mAdvancedFilter->toJson());
    raiseNewInternalLoadingStatus(Ready);
    setLoading(false);
}

void FilteringAnalysis::raiseNewInternalLoadingStatus(LoadingStatus newStatus)
{
    emit loadingStatusChanged(mLoadingStatus, newStatus);
    mLoadingStatus = newStatus;
}








// ------------------------------------------------------------------------------------------------
// Sets

void FilteringAnalysis::resetSets()
{
    mSets.clear();
    // add samples first
    for (Sample* sample: mSamples)
    {
        mSets.append(new Set(QString("sample"), QString::number(sample->id()), sample->nickname()));
    }

    // add sample's attributes
    for (QObject* o: mAttributes)
    {
        Attribute* attribute = qobject_cast<Attribute*>(o);
        for (const QString& attrValue: attribute->getMapping().keys())
        {
            QString label = attribute->name() + QString(": ") + attrValue;
            mSets.append(new Set(QString("attr"), attribute->getMapping()[attrValue], label));
        }
    }

    // add filters
    for (QObject* o: mFilters)
    {
        SavedFilter* filter = qobject_cast<SavedFilter*>(o);
        mSets.append(new Set("filter", QString::number(filter->id()), filter->name()));
    }

    // add panels
    for (QString& panelId: mPanelsUsed)
    {
        Panel* panel = regovar->panelsManager()->getOrCreatePanel(panelId);
        mSets.append(new Set("panel", panel->versionId(), panel->fullname() ));
    }

    emit setsChanged();
}

Set* FilteringAnalysis::getSetById(QString type, QString id)
{
    for (QObject* o: mSets)
    {
        Set* set = qobject_cast<Set*>(o);
        if (set->type() == type && set->id() == id)
        {
            return set;
        }
    }
    return nullptr;
}





// ------------------------------------------------------------------------------------------------
// Saved Filter

void FilteringAnalysis::loadFilter(QString filter)
{
    QJsonDocument doc = QJsonDocument::fromJson(filter.toUtf8());
    loadFilter(doc.array());
}

void FilteringAnalysis::loadFilter(QJsonObject filter)
{
    loadFilter(filter["filter"].toArray());
}

void FilteringAnalysis::loadFilter(QJsonArray filter)
{
    // mQuickFilters->loadFilter(filter);
    mAdvancedFilter->loadJson(filter);
    setFilterJson(filter);
}

void FilteringAnalysis::setFilterOrder(int column, bool order)
{
    // As QML table is not able to mnage sort with several column, we force ordering with only one column
    if (column >= 0 && column < mDisplayedAnnotations.count())
    {
        mOrder.clear();
        FieldColumnInfos* info = qobject_cast<FieldColumnInfos*>(mDisplayedAnnotations[column]);
        if (info->isAnnotation() && !mOrder.contains(info->uid()) &&!mOrder.contains(QString("-%1").arg(info->uid())))
        {
            mOrder << QString("%1%2").arg(order ? "-" : "").arg(info->uid());
            // Force Variant table to refresh
            mResults->applyFilter(mFilterJson);
        }
    }
}

void FilteringAnalysis::deleteFilter(int filterId)
{
    Request* req = Request::del(QString("/analysis/%1/filter/%2").arg(mId).arg(filterId));
    connect(req, &Request::responseReceived, [this, req, filterId](bool success, const QJsonObject& json)
    {
        if (success)
        {
            // Removing the saved filter
            SavedFilter* filter = getSavedFilterById(filterId);
            mFilters.removeAll(filter);
            resetSets();
            emit filtersChanged();
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}

void FilteringAnalysis::editFilter(int filterId, QString filterName, QString filterDescription, bool saveAdvancedFilter)
{
    QJsonObject body;
    body.insert("name", filterName);
    if (!filterDescription.isEmpty())
    {
        body.insert("description", filterDescription);
    }
    if (saveAdvancedFilter)
    {
        QJsonArray filter;
        filter = mAdvancedFilter->toJson();
        body.insert("filter", filter);
    }

    Request* req;
    if (filterId != -1)
    {
        body.insert("id", filterId);
        req = Request::put(QString("/analysis/%1/filter/%2").arg(mId).arg(filterId), QJsonDocument(body).toJson());
    }
    else
    {
        req = Request::post(QString("/analysis/%1/filter").arg(mId), QJsonDocument(body).toJson());
    }

    connect(req, &Request::responseReceived, [this, req, filterName](bool success, const QJsonObject& json)
    {
        if (success)
        {
            // Update model with filter data from the server
            QJsonObject jsonData = json["data"].toObject();
            int id = jsonData["id"].toInt();

            SavedFilter* filter = getSavedFilterById(id);
            if (filter != nullptr)
            {
                // Edit
                filter->fromJson(jsonData);
            }
            else
            {
                // New filter
                mFilters.append(new SavedFilter(json["data"].toObject()));
                setCurrentFilterName(filterName);
            }
            resetSets();
            emit filtersChanged();
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}

SavedFilter* FilteringAnalysis::getSavedFilterById(int id)
{
    for (QObject* o: mFilters)
    {
        SavedFilter* filter = qobject_cast<SavedFilter*>(o);
        if (filter->id() == id)
        {
            return filter;
        }
    }
    return nullptr;
}





// ------------------------------------------------------------------------------------------------
// Samples

void FilteringAnalysis::addSamples(QList<QObject*> samples)
{
    for (QObject* o1: samples)
    {
        Sample* sample = qobject_cast<Sample*>(o1);
        if (!mSamplesIds.contains(sample->id()))
        {
            mSamplesIds.append(sample->id());
            mSamples.append(sample);
        }
    }
    emit samplesChanged();
}

void FilteringAnalysis::removeSamples(QList<QObject*> samples)
{
    for (QObject* o1: samples)
    {
        Sample* sample = qobject_cast<Sample*>(o1);
        if (mSamplesIds.contains(sample->id()))
        {
            mSamplesIds.removeAll(sample->id());
            mSamples.removeAll(sample);
        }
    }
    emit samplesChanged();
}

void FilteringAnalysis::addSamplesFromFile(int fileId)
{
    Request* req = Request::get(QString("/sample/import/%1/%2").arg(QString::number(fileId), QString::number(mRefId)));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            for (const QJsonValue& sampleValue: json["data"].toArray())
            {
                QJsonObject sampleData = sampleValue.toObject();
                Sample* sample = regovar->samplesManager()->getOrCreateSample(sampleData["id"].toInt());
                if (sample->fromJson(sampleData))
                {
                    if (!mSamplesIds.contains(sample->id()))
                    {
                        mSamplesIds.append(sample->id());
                        mSamples.append(sample);
                    }
                }
            }
            emit samplesChanged();
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
            raiseNewInternalLoadingStatus(Error);
        }
        req->deleteLater();
    });
}

Sample* FilteringAnalysis::getSampleById(int id)
{
    for (QObject* o: mSamples)
    {
        Sample* sample = qobject_cast<Sample*>(o);
        if (sample->id() == id)
        {
            return sample;
        }
    }
    return nullptr;
}




void FilteringAnalysis::addSampleInputs(QList<QObject*> inputs)
{
    for (QObject* o: inputs)
    {
        if (!mSamplesInputsFilesList.contains(o))
        {
            mSamplesInputsFilesList.append(o);
        }
    }
    emit samplesInputsFilesListChanged();
}

void FilteringAnalysis::removeSampleInputs(QList<QObject*> inputs)
{
    for (QObject* o: inputs)
    {
        mSamplesInputsFilesList.removeAll(o);
    }
    emit samplesInputsFilesListChanged();
}




// ------------------------------------------------------------------------------------------------
// Samples Attributes

void FilteringAnalysis::saveAttribute(QString name, QStringList values)
{
    Attribute* attr = new Attribute(name);
    int idx = 0;
    for (Sample* sample: mSamples)
    {
        attr->setValue(sample->id(), values[idx]);
        idx++;
    }
    mAttributes.append(attr);
    emit attributesChanged();
}

void FilteringAnalysis::deleteAttribute(QStringList names)
{
    for (int idx=mAttributes.count()-1; idx>=0; idx --)
    {
        Attribute* attr = qobject_cast<Attribute*>(mAttributes[idx]);
        if (names.contains(attr->name()))
        {
            mAttributes.removeAt(idx);
        }
    }
    emit attributesChanged();
}



// ------------------------------------------------------------------------------------------------
// Result

void FilteringAnalysis::saveHeaderPosition(int oldPosition, int newPosition)
{
    mQtBugWorkaround_QMLHeaderDelegatePressedEventCalledTwice++;
    if (mQtBugWorkaround_QMLHeaderDelegatePressedEventCalledTwice % 2 == 0) return;

    if (oldPosition < 0 || oldPosition >= mDisplayedAnnotations.count()) return;
    if (newPosition < 0 || newPosition >= mDisplayedAnnotations.count()) return;

    FieldColumnInfos* info = qobject_cast<FieldColumnInfos*>(mDisplayedAnnotations[oldPosition]);
    if (info && info->annotation())
    {
        // Apply change to the model
        mDisplayedAnnotations.move(oldPosition, newPosition);
        // Recompute field order without "client columns" (_rowHeader & _Samples)
        mFields.clear();
        for (QObject* o: mDisplayedAnnotations)
        {
            FieldColumnInfos* info = qobject_cast<FieldColumnInfos*>(o);
            if (info->isAnnotation())
            {
                mFields.append(info->annotation()->uid());
            }
        }
        saveSettings();
    }
}

void FilteringAnalysis::saveHeaderWidth(int headerPosition, double newSize)
{
    if (headerPosition < 0 || headerPosition >= mDisplayedAnnotations.count()) return;

    FieldColumnInfos* info = qobject_cast<FieldColumnInfos*>(mDisplayedAnnotations[headerPosition]);
    if (info && info->annotation())
    {
        info->setWidth(newSize);
        saveSettings();
    }
}





// ------------------------------------------------------------------------------------------------
// Misc


void FilteringAnalysis::processPushNotification(QString action, QJsonObject data)
{
    // update done in regovar on the global remote list

    if (action == "wt_creation")
    {
        mStatus = data["status"].toString();
        mComputingProgress = data;
        emit statusChanged();
        if (mStatus == "ready")
        {
            load(true);
        }
    }
    else if (action == "wt_update")
    {
        // get data to update
        double progress = data["progress"].toDouble();
        QString column = data["column"].toString();
        int colId = column.split("_")[1].toInt();

        if (column.startsWith("filter_"))
        {
            // update saved filter progress
            for (QObject* o: mFilters)
            {
                SavedFilter* filter = qobject_cast<SavedFilter*>(o);
                if (filter->id() == colId)
                {
                    filter->setProgress(progress);
                    if (progress == 1)
                    {
                        filter->setCount(data["count"].toInt());
                    }
                    emit filtersChanged();
                    break;
                }
            }
        }
    }
    else if (action == "filter_update")
    {
        // get data to update
        int filterId = data["id"].toInt();

        // update saved filter progress
        for (QObject* o: mFilters)
        {
            SavedFilter* filter = qobject_cast<SavedFilter*>(o);
            if (filter->id() == filterId)
            {
                filter->fromJson(data);
                break;
            }
        }

    }
}


/// Save on local computer, Tableariant columns settings (order of columns displayed and width)
void FilteringAnalysis::saveSettings()
{
    QSettings settings;
    settings.beginWriteArray(QString("analysis/%1/resultsHeadersSizes").arg(mId));
    int idx=0;
    for (QObject* o: mDisplayedAnnotations)
    {
        FieldColumnInfos* info = qobject_cast<FieldColumnInfos*>(o);
        if (info->annotation())
        {
            settings.setArrayIndex(idx);
            settings.setValue("uid", info->annotation()->uid());
            settings.setValue("width", info->width());
            idx++;
        }
    }
    settings.endArray();
}

/// Restore Tableariant columns settings stored on the local computer
void FilteringAnalysis::loadSettings()
{
    qDebug() << QTime::currentTime().toString() << "LOAD local settings";
    QSettings settings;

    // Reload Analysis result headers states
    int size = settings.beginReadArray(QString("analysis/%1/resultsHeadersSizes").arg(mId));

    QStringList fields;
    for (int pos = 0; pos < size; pos++)
    {
        settings.setArrayIndex(pos);
        QString fuid = settings.value("uid").toString();
        double width = settings.value("width").toDouble();
        FieldColumnInfos* info = mAnnotations[fuid];

        if (info)
        {
            info->setWidth(width);
            if (info->isAnnotation())
            {
                fields.append(fuid);
            }
        }
    }
    settings.endArray();

    // Force load of last selected fields if exists.
    // Otherwise use last fields config saved on the server
    if (fields.count() > 0)
    {
        mFields.clear();
        for (QString uid: fields)
        {
            mFields << uid;
        }
    }
    qDebug() << QTime::currentTime().toString() << "LOAD local settings DONE";

    // Update columns to display in the QML view according to selected annoations
    initDisplayedAnnotations();
    saveSettings();

    // Force Variant table to refresh
    qDebug() << QTime::currentTime().toString() << "APPLY FILTER : SEND";
    mResults->applyFilter(mFilterJson);

}


void FilteringAnalysis::setVariantSelection(QString id, bool isChecked)
{
    QString action = isChecked ? "select" : "unselect";

    Request* req = Request::get(QString("/analysis/%1/%2/%3").arg(QString::number(mId), action, id));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (!success)
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
            raiseNewInternalLoadingStatus(Error);
        }
        req->deleteLater();
    });
}



void FilteringAnalysis::addFile(File* file)
{
    if (file != nullptr && !mFiles.contains(file))
    {
        // Update analysis to add file list
        mFiles.append(file);
        int fileId = file->id();
        // Synch with server
        Request* request = Request::put(QString("/analysis/%1").arg(mId), QJsonDocument(toJson()).toJson());
        connect(request, &Request::responseReceived, [this, fileId, request](bool success, const QJsonObject& json)
        {
            if (success)
            {
                QJsonObject data = json["data"].toObject();
                // Refresh document list
                mDocumentsTreeModel->refresh(data);
                emit fileAdded(fileId);
            }
            else
            {
                QJsonObject jsonError = json;
                jsonError.insert("method", Q_FUNC_INFO);
                regovar->raiseError(jsonError);
            }
            request->deleteLater();
        });
    }
}
