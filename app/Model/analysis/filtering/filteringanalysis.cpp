#include "filteringanalysis.h"

#include "Model/framework/request.h"
#include "Model/regovar.h"
#include "annotation.h"

FilteringAnalysis::FilteringAnalysis(QObject *parent) : Analysis(parent)
{
    // Tree model are created to allow QML binding initialisation even if no data loaded
    mType = "Filtering";
    mResults = new ResultsTreeModel(this);
    mAnnotationsTreeModel = new AnnotationsTreeModel(this);
    mQuickFilters = new QuickFilterModel(this);
    mAdvancedFilter = new AdvancedFilterModel(this);
    mNewConditionModel = new NewAdvancedFilterModel(this);
    mLoadingStatus = Empty;


    connect(this, SIGNAL(loadingStatusChanged(LoadingStatus,LoadingStatus)),
            this, SLOT(asynchLoadingCoordination(LoadingStatus,LoadingStatus)));
    connect(regovar, SIGNAL(websocketMessageReceived(QString,QJsonObject)),
            this, SLOT(onWebsocketMessageReceived(QString,QJsonObject)));


    setIsLoading(true);
}


FilteringAnalysis::FilteringAnalysis(int id, QObject* parent) : FilteringAnalysis(parent)
{
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
    setLastUpdate(QDateTime::fromString(json["update_date"].toString(), Qt::ISODate));
    mStatus = json["status"].toString();

    // Getting ref
    Reference* ref = regovar->referenceFromId(json["reference_id"].toInt());
    if (ref == nullptr)
    {
        qDebug() << "Reference unknow !";
        return false;
    }
    mQuickFilters->init(ref->id(), mId);

    // Parse settings
    QJsonObject settings = json["settings"].toObject();
    foreach (const QJsonValue field, settings["annotations_db"].toArray())
    {
        mAnnotationsDBUsed << field.toString();
    }
    if (settings["trio"].isBool())
    {
        mIsTrio = false;
    }
    else
    {
        mIsTrio = true;
    }

    // Retrieve samples
    mSamples.clear();
    foreach (const QJsonValue spJson, json["samples"].toArray())
    {
        Sample* sample = new Sample(this);
        if(sample->fromJson(spJson.toObject()))
        {
            mSamples.append(sample);
        }
    }
    emit samplesChanged();


    // Retrieve saved filters
    mFilters.clear();
    foreach (const QJsonValue filterdata, json["filters"].toArray())
    {
        mFilters.append(new SavedFilter(filterdata.toObject()));
    }
    emit filtersChanged();

    // Retrieve samples attributes
    mAttributes.clear();
    foreach (const QJsonValue attributedata, json["attributes"].toArray())
    {
        mAttributes.append(new Attribute(attributedata.toObject()));
    }
    emit attributesChanged();

    // Retrieve fields
    foreach (const QJsonValue field, json["fields"].toArray())
    {
        mFields << field.toString();
    }

    // Retrieve order
    foreach (const QJsonValue field, json["order"].toArray())
    {
        mOrder << field.toString();
    }

    // Once samples, attributes, filters and panels have been retrieved, create unique list of sets
    resetSets();


    // Loading of an analysis required several asynch steps
    // 1 : need to retrieve all complient annotations DB (need it when creating new analysis)
    // 2 : next init model with all available annotation's fields and setup GUI model to display only selected annotations
    // 3 : prepare quick filter (they need to check that they are complient with available annotations
    // 4 : set filter with the last applied filter
    // 5 : load results
    // Chaining of loading step is done thanks to signals (see asynchLoading slot)

    // The "true" loading of the filter must be done only after that annotation* informations have been loaded
    // so for the init, we just save json filter, without loading/signal
    mFilterJson = json["filter"].toArray();

    // Set the ref and start (if needed) the next asynch loading step
    setReference(ref, full_init);

    return true;
}




QJsonObject FilteringAnalysis::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("name", mName);
    result.insert("comment", mComment);
//    if (mParent != nullptr)
//    {
//        result.insert("parent_id", mParent->id());
//    }
//    // Analyses
//    if (mAnalyses.count() > 0)
//    {
//        QJsonArray analyses;
//        foreach (QObject* o, mAnalyses)
//        {
//            FilteringAnalysis* a = qobject_cast<FilteringAnalysis*>(o);
//            analyses.append(a->id());
//        }
//        result.insert("analyses_ids", analyses);
//    }
    // TODO: Jobs
    // TODO: Indicators

    return result;
}

void FilteringAnalysis::save()
{
    if (mId == -1) return;
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

void FilteringAnalysis::load()
{
    if (mId == -1) return;

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
    emit dataChanged();

    if (!continueInit) return;

    // STEP 1 : Load all available complient annotations DB
    Request* req = Request::get(QString("/annotation/%1").arg(mRefId));
    connect(req, &Request::responseReceived, [this, req, continueInit](bool success, const QJsonObject& json)
    {
        mAllAnnotations.clear();
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            foreach (const QJsonValue dbjson, data["db"].toArray())
            {
                QJsonObject db = dbjson.toObject();
                QString name = db["name"].toString();
                QString desc = db["description"].toString();
                QString duid = db["default"].toString();
                QJsonObject djsn = db["versions"].toObject();
                foreach (const QString dbuid, djsn.keys())
                {
                    QJsonObject dbv = djsn[dbuid].toObject();
                    QString version = dbv["version"].toString();
                    QJsonArray fields = dbv["fields"].toArray();
                    bool isHeadVersion = duid == dbv["uid"].toString();
                    AnnotationDB* adb = new AnnotationDB(dbuid, name, desc, version, isHeadVersion, fields, this);
                    mAllAnnotations.append(adb);
                }
            }

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
        emit allAnnotationsChanged();
        emit selectedAnnotationsDBChanged();
        req->deleteLater();
    });
}






void FilteringAnalysis::asynchLoadingCoordination(LoadingStatus oldSatus, LoadingStatus newStatus)
{
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
    // Init list of displayed columns according to analysis settings
    mAnnotations.clear();
    mAnnotationsFlatList.clear();
    mAnnotations.insert("_RowHead", new FieldColumnInfos(nullptr, true, 0, "", this));
    mAnnotations.insert("_Samples", new FieldColumnInfos(nullptr, false, -1, "", this));
    mAnnotations["_RowHead"]->setRole(FieldColumnInfos::RowHeader);
    mAnnotations["_Samples"]->setRole(FieldColumnInfos::SamplesNames);

    // Update annotations databases
    foreach (QObject* o, mAllAnnotations)
    {
        AnnotationDB* db = qobject_cast<AnnotationDB*>(o);
        if (mAnnotationsDBUsed.contains(db->uid()) || db->isMandatory())
        {
            db->setSelected(true);
            foreach (Annotation* annot, db->fields())
            {
                QString uid = annot->uid();
                FieldColumnInfos* fInfo = new FieldColumnInfos(annot, mFields.contains(uid), mFields.indexOf(uid), "", this);
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
    mQuickFilters->checkAnnotationsDB(mAllAnnotations);

    // set filter with the last applied filter
    loadFilter(mFilterJson);

    // Init columns displayed in the results table
    refreshDisplayedAnnotationColumns();

    // Load results(asynch)
    raiseNewInternalLoadingStatus(LoadingResults);
}

void FilteringAnalysis::refreshDisplayedAnnotationColumns()
{
    // Set list of displayed columns
    mDisplayedAnnotationColumns.clear();
    mDisplayedAnnotationColumns.append(mAnnotations["_RowHead"]);
    mAnnotations["_Samples"]->setIsDisplayed(false);
    int idx = 1;
    foreach( QString uid, mFields)
    {
        if (mAnnotations.contains(uid))
        {
            if (mAnnotations[uid]->annotation()->type() == "sample_array" && !mAnnotations["_Samples"]->isDisplayed())
            {
                mAnnotations["_Samples"]->setIsDisplayed(true);
                mDisplayedAnnotationColumns.append(mAnnotations["_Samples"]);
                ++idx;
            }
            mDisplayedAnnotationColumns.append(mAnnotations[uid]);
            ++idx;
        }
    }
    emit resultColumnsChanged();
}






QList<QObject*> FilteringAnalysis::samples4qml()
{
    QList<QObject*> result;
    foreach (Sample* sp, mSamples)
    {
        QObject* obj = qobject_cast<QObject*>(sp);
        result << obj;
    }
    return result;
}
QStringList FilteringAnalysis::resultColumns()
{
    QStringList list;
    foreach (FieldColumnInfos* field, mDisplayedAnnotationColumns)
    {
        if (field->role() == FieldColumnInfos::NormalAnnotation)
        {
            list << field->annotation()->uid();
        }
        else if (field->role() == FieldColumnInfos::SamplesNames)
        {
            list << "_Samples";
        }
        else if (field->role() == FieldColumnInfos::RowHeader)
        {
            list << "_RowHead";
        }
    }
    return list;
}

QStringList FilteringAnalysis::selectedAnnotationsDB()
{
    QStringList list;
    foreach (QObject* o, mAllAnnotations)
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
    mResults->initAnalysisData(mId);
    mResults->applyFilter(mAdvancedFilter->toJson());
    raiseNewInternalLoadingStatus(Ready);
    setIsLoading(false);
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
    foreach (Sample* sample, mSamples)
    {
        mSets.append(new Set(QString("sample"), QString::number(sample->id()), sample->nickname()));
    }

    // add sample's attributes
    foreach (QObject* o, mAttributes)
    {
        Attribute* attribute = qobject_cast<Attribute*>(o);
        foreach (QString attrValue, attribute->getMapping().keys())
        {
            QString label = attribute->name() + QString(": ") + attrValue;
            mSets.append(new Set(QString("attr"), attribute->getMapping()[attrValue], label));
        }
    }

    // add filters
    foreach (QObject* o, mFilters)
    {
        SavedFilter* filter = qobject_cast<SavedFilter*>(o);
        mSets.append(new Set("filter", QString::number(filter->id()), filter->name()));
    }

    // add panels
    // Todo

    emit setsChanged();
}

Set* FilteringAnalysis::getSetById(QString type, QString id)
{
    foreach (QObject* o, mSets)
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
    mOrder.clear();
    FieldColumnInfos* info = mDisplayedAnnotationColumns[column];
    if (info->role() == FieldColumnInfos::NormalAnnotation)
    {
        mOrder << QString("%1%2").arg(order ? "-" : "").arg(info->annotation()->uid());
        // Force Variant table to refresh
        mResults->applyFilter(mFilterJson);
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
    foreach (QObject* o, mFilters)
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
    foreach(QObject* o1, samples)
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
    foreach(QObject* o1, samples)
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
            foreach (QJsonValue sampleValue, json["data"].toArray())
            {
                Sample* sample = new Sample();
                if (sample->fromJson(sampleValue.toObject()))
                {
                    if (!mSamplesIds.contains(sample->id()))
                    {
                        mSamplesIds.append(sample->id());
                        mSamples.append(sample);
                    }
                }
                else
                {
                    sample->deleteLater();
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
    foreach (QObject* o, mSamples)
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
    foreach(QObject* o, inputs)
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
    foreach(QObject* o, inputs)
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
    foreach (Sample* sample, mSamples)
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

//! Add or remove a field to the display result and update or set the order
void FilteringAnalysis::setField(QString uid, bool isDisplayed, int position, bool internalUpdate)
{
    Annotation* annot = mAnnotationsTreeModel->getAnnotation(uid);

    if (annot == nullptr)
    {
        qDebug() << "TODO : on check db : need to check/uncheck all fields";
        return;
    }

    if (isDisplayed)
    {
        if (position < 0)
        {
            mFields.removeAll(uid);
            mFields << uid;
        }
        else
        {
            position = qMin(position, mFields.count()-1);
            mFields.removeAll(uid);
            mFields.insert(position, uid);
        }
    }
    else
    {
        mFields.removeAll(uid);
    }


    if (!internalUpdate)
    {
        // Update columns to display in the QML view according to selected annoations
        refreshDisplayedAnnotationColumns();
        saveSettings();

        // Force Variant table to refresh
        mResults->applyFilter(mFilterJson);
    }
}

void FilteringAnalysis::saveHeaderPosition(int oldPosition, int newPosition)
{
    mQtBugWorkaround_QMLHeaderDelegatePressedEventCalledTwice++;
    if (mQtBugWorkaround_QMLHeaderDelegatePressedEventCalledTwice % 2 == 0) return;

    if (oldPosition < 0 || oldPosition >= mDisplayedAnnotationColumns.count()) return;
    if (newPosition < 0 || newPosition >= mDisplayedAnnotationColumns.count()) return;

    FieldColumnInfos* info = mDisplayedAnnotationColumns[oldPosition];
    if (info && info->annotation())
    {
        // Apply change to the model
        mDisplayedAnnotationColumns.move(oldPosition, newPosition);
        // Recompute field order without "client columns" (_rowHeader & _Samples)
        mFields.clear();
        foreach (FieldColumnInfos* info, mDisplayedAnnotationColumns)
        {
            if (info->role() == FieldColumnInfos::NormalAnnotation)
            {
                mFields.append(info->annotation()->uid());
            }
        }
        saveSettings();
    }
}

void FilteringAnalysis::saveHeaderWidth(int headerPosition, double newSize)
{
    if (headerPosition < 0 || headerPosition >= mDisplayedAnnotationColumns.count()) return;

    FieldColumnInfos* info = mDisplayedAnnotationColumns[headerPosition];
    if (info && info->annotation())
    {
        info->setWidth(newSize);
        saveSettings();
    }
}





// ------------------------------------------------------------------------------------------------
// Misc


void FilteringAnalysis::onWebsocketMessageReceived(QString action, QJsonObject data)
{
    // update done in regovar on the global remote list

    // Check that we are concerned by the message
    int analysisId = data["analysis_id"].toInt();
    if (analysisId != mId) return;

    if (action == "wt_update")
    {
        // get data to update
        double progress = data["progress"].toDouble();
        QString column = data["column"].toString();
        int colId = column.split("_")[1].toInt();

        if (column.startsWith("filter_"))
        {
            // update saved filter progress
            foreach (QObject* o, mFilters)
            {
                SavedFilter* filter = qobject_cast<SavedFilter*>(o);
                if (filter->id() == colId)
                {
                    filter->setProgress(progress);
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
        foreach (QObject* o, mFilters)
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



void FilteringAnalysis::saveSettings()
{
    QSettings settings;
    settings.beginWriteArray(QString("analysis/%1/resultsHeadersSizes").arg(mId));
    int idx=0;
    foreach (FieldColumnInfos* info, mDisplayedAnnotationColumns)
    {
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
void FilteringAnalysis::loadSettings()
{
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
            if (info->role() == FieldColumnInfos::NormalAnnotation)
            {
                fields.append(fuid);
            }
        }
    }
    settings.endArray();
    if (fields.count() > 0)
    {
        mFields.clear();
        foreach(QString fuid, fields) { setField(fuid, true, -1, true); }

        // Update columns to display in the QML view according to selected annoations
        refreshDisplayedAnnotationColumns();

        // Force Variant table to refresh
        mResults->applyFilter(mFilterJson);
    }
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



void FilteringAnalysis::addFile(File*)
{
    // TODO
}
