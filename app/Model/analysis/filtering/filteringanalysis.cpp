#include "filteringanalysis.h"

#include "Model/request.h"
#include "Model/regovar.h"
#include "annotation.h"

FilteringAnalysis::FilteringAnalysis(QObject *parent) : Analysis(parent)
{
    // Tree model are created to allow QML binding initialisation even if no data loaded
    mType = tr("Variants Filtering");
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


bool FilteringAnalysis::fromJson(QJsonObject json)
{
    // load basic data from json
    setId(json["id"].toInt());
    setName(json["name"].toString());
    setComment(json["comment"].toString());
    setType("Dynamic filtering analysis");
    setLastUpdate(QDateTime::fromString(json["update_date"].toString(), Qt::ISODate));
    mStatus = json["status"].toString();

    // Getting ref
    Reference* ref = regovar->referencesFromId(json["reference_id"].toInt());
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

    // Init remote samples tree model
    mRemoteSampleTreeModel = new RemoteSampleTreeModel(this);
    emit remoteSamplesChanged();


    // Retrieve saved filters
    mSavedFilters.clear();
    foreach (const QJsonValue filterdata, json["filters"].toArray())
    {
        mSavedFilters.append(filterdata.toObject());
    }
    emit filterChanged();

    // Retrieve fields
    foreach (const QJsonValue field, json["fields"].toArray())
    {
        QString uid = field.toString();
        mFields << uid;
        qDebug() << " - " << uid;
    }



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

    // Set the ref and start the next asynch loading step
    setReference(ref, true);

    return true;
}


//! Set the reference for the analysis, and load all available annotations available for this ref (async)
void FilteringAnalysis::setReference(Reference* ref, bool continueInit)
{
    if (ref->id() == mRefId) return;


    // Set current ref
    mRefId = ref->id();
    mRefName = ref->name();
    emit refChanged();

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
            if (continueInit) raiseNewInternalLoadingStatus(LoadingAnnotations);
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
    // TODO : CRASH SOUS WINDOWS ? MAIS PAS SOUS LINUX...
    // mQuickFilters->checkAnnotationsDB(mAllAnnotations);

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
    mAnnotations["_Samples"]->setIsDisplayed(false);
    int idx = 0;
    foreach( QString uid, mFields)
    {
        if (mAnnotations.contains(uid))
        {
            if (mAnnotations[uid]->annotation()->type() == "sample_array" && !mAnnotations["_Samples"]->isDisplayed())
            {
                mAnnotations["_Samples"]->setDisplayOrder(idx);
                mAnnotations["_Samples"]->setIsDisplayed(true);
                mDisplayedAnnotationColumns.append(mAnnotations["_Samples"]);
                ++idx;
            }
            mAnnotations[uid]->setDisplayOrder(idx);
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
    list << "_RowHead";
    foreach (FieldColumnInfos* field, mDisplayedAnnotationColumns)
    {
        // TODO : rework better the special case for UI additional column "samples"
        if (field->role() == FieldColumnInfos::NormalAnnotation)
        {
            list << field->annotation()->uid();
        }
        else if (field->role() == FieldColumnInfos::SamplesNames)
        {
            list << "_Samples";
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


void FilteringAnalysis::getVariantInfo(QString variantId)
{
    QString refId = QString::number(mRefId);
    QString analysisId = QString::number(mId);

    Request* req = Request::get(QString("/variant/%1/%2/%3").arg(refId, variantId, analysisId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            emit onContextualVariantInformationReady(json["data"].toObject());
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





void FilteringAnalysis::saveCurrentFilter(bool quickFilter, QString filterName, QString filterDescription)
{
    QJsonArray filter;
    if (quickFilter)
    {
        //QJsonDocument f = QJsonDocument::fromJson(QString::toUtf8());
        filter = mQuickFilters->toJson();
    }
    else
    {
        filter = mAdvancedFilter->toJson();
    }

    QJsonObject body;
    body.insert("filter", filter);
    body.insert("name", filterName);
    if (!filterDescription.isEmpty())
    {
        body.insert("description", filterDescription);
    }

    Request* req = Request::post(QString("/analysis/%1/filter").arg(mId), QJsonDocument(body).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            // TODO : refresh list of filter in the view
            qDebug() << "Filter saved !";
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


//! Add or remove a field to the display result and update or set the order
//! Return the order of the field in the grid
int FilteringAnalysis::setField(QString uid, bool isDisplayed, int order)
{
    Annotation* annot = mAnnotationsTreeModel->getAnnotation(uid);

    if (isDisplayed)
    {
        if (order != -1)
        {
            order = qMin(order, mFields.count()-1);
            mFields.removeAll(uid);
            mFields.insert(order, uid);
        }
        else
        {
            mFields.removeAll(uid);
            order = mFields.count()-1;
            mFields << uid;
        }
    }
    else
    {
        order = mFields.indexOf(uid);
        mFields.removeAll(uid);
    }
    annot->setOrder(order);


//    foreach (QString uid, mFields)
//    {
//        annot = regovar->currentFilteringAnalysis()->annotations()->getAnnotation(uid);
//        if (annot->)
//    }


    emit fieldsChanged();

    // Update columns to display in the QML view according to selected annoations
    refreshDisplayedAnnotationColumns();
    return order;
}





void FilteringAnalysis::onWebsocketMessageReceived(QString action, QJsonObject data)
{
    // update done in regovar on the global remote list
}






