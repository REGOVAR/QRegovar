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
    mLoadingStatus = empty;


    connect(this, SIGNAL(loadingStatusChanged(LoadingStatus,LoadingStatus)),
            this, SLOT(asynchLoadingCoordination(LoadingStatus,LoadingStatus)));
    connect(regovar, SIGNAL(websocketMessageReceived(QString,QJsonObject)),
            this, SLOT(onWebsocketMessageReceived(QString,QJsonObject)));
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
    mFilters.clear();
    foreach (const QJsonValue filterdata, json["filters"].toArray())
    {
        mFilters.append(filterdata.toObject());
    }
    emit filtersChanged();

    // Retrieve fields
    foreach (const QJsonValue field, json["fields"].toArray())
    {
        QString uid = field.toString();
        mFields << uid;
        qDebug() << " - " << uid;
    }

    // Retrieve filter
    setFilterJson(json["filter"].toArray());
    QJsonDocument doc;
    doc.setArray(mFilterJson);
    setFilter(QString(doc.toJson(QJsonDocument::Indented)));
    // init UI according to filter
    // mQuickFilters->loadFilter(mFilterJson);




    mResults->initAnalysisData(mId);
    mQuickFilters->init(mRefId, mId);

    // Loading of an analysis required several asynch steps
    // 1 : need to load alls annotations available accdording to the referencial
    // 2 : prepare quick filter (they need to check that they are complient with available annotations
    // 3 : set filter with the last applied filter
    // 4 :
    // 5 : load results
    // Chaining of loading step is done thanks to signals (see asynchLoading slot)
    Reference* ref = regovar->referencesFromId(json["reference_id"].toInt());
    if (ref == nullptr) return false;
    setReference(ref, true);


    return true;
}


void FilteringAnalysis::setReference(Reference* ref, bool continueInit)
{
    if (ref->id() == mRefId) return;

    // Set current ref
    mRefId = ref->id();
    mRefName = ref->name();
    emit refChanged();

    // Load complient annotations DB
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

            // continue by loading results
            if (continueInit)
            {
                emit loadingStatusChanged(mLoadingStatus, loadingAnnotations);
                mLoadingStatus = loadingAnnotations;
            }
        }
        else
        {
            regovar->raiseError(json);
            emit loadingStatusChanged(mLoadingStatus, error);
            mLoadingStatus = error;
        }
        emit allAnnotationsChanged();
        emit selectedAnnotationsDBChanged();
        req->deleteLater();
    });
}






void FilteringAnalysis::asynchLoadingCoordination(LoadingStatus oldSatus, LoadingStatus newStatus)
{
    if (newStatus == loadingAnnotations)
    {
        loadAnnotations();
    }
    else if (newStatus == LoadingResults)
    {
        loadResults();
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


    // Init columns displayed in the results table
    refreshDisplayedAnnotationColumns();

    // Load results(asynch)
    emit loadingStatusChanged(mLoadingStatus, LoadingResults);
    mLoadingStatus = LoadingResults;
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


void FilteringAnalysis::loadResults()
{
    QJsonObject body;
    QJsonDocument filter = QJsonDocument::fromJson(mFilter.toUtf8());
    body.insert("filter", filter.array());
    body.insert("fields", QJsonArray::fromStringList(mFields));

    Request* req = Request::post(QString("/analysis/%1/filtering").arg(mId), QJsonDocument(body).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            if (mResults->fromJson(json["data"].toObject()))
            {
                emit loadingStatusChanged(mLoadingStatus, ready);
                mLoadingStatus = ready;
            }
            else
            {
                qDebug() << "Filtering analysis init : Failed to load result";
                emit loadingStatusChanged(mLoadingStatus, error);
                mLoadingStatus = error;
            }
        }
        else
        {
            regovar->raiseError(json);
            emit loadingStatusChanged(mLoadingStatus, error);
            mLoadingStatus = error;
        }
        req->deleteLater();
    });
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
            regovar->raiseError(json);
        }
        req->deleteLater();
    });
}





void FilteringAnalysis::saveCurrentFilter(QString filterName, QString filterDescription)
{
    QJsonObject body;
    QJsonDocument filter = QJsonDocument::fromJson(mFilter.toUtf8());
    body.insert("filter", filter.array());
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
            regovar->raiseError(json);
        }
        req->deleteLater();
    });
}



void FilteringAnalysis::loadFilter(QString filter)
{
    QJsonDocument doc = QJsonDocument::fromJson(filter.toUtf8());
    setFilter(filter);
    setFilterJson(doc.array());

    // TODO : Abandonned ? as quickfilter are too limitated to load every filters possibilities
    // init UI according to filter
    // mQuickFilters->loadFilter(mFilterJson);
}
void FilteringAnalysis::loadFilter(QJsonObject filter)
{
    // Retrieve filter
    setFilterJson(filter["filter"].toArray());
    QJsonDocument doc;
    doc.setArray(mFilterJson);
    setFilter(QString(doc.toJson(QJsonDocument::Indented)));

    // TODO : Abandonned ? as quickfilter are too limitated to load every filters possibilities
    // init UI according to filter
    // mQuickFilters->loadFilter(mFilterJson);
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
    Request* req = Request::get(QString("/sample/import/%1/%2").arg(QString(fileId), QString(mRefId)));
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
            regovar->raiseError(json);
            emit loadingStatusChanged(mLoadingStatus, error);
            mLoadingStatus = error;
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
    if (action == "import_vcf_processing")
    {
        double progressValue = data["progress"].toDouble();
        QString status = data["status"].toString();

        foreach(QJsonValue json, data["samples"].toArray())
        {
            QJsonObject obj = json.toObject();
            int sid = obj["id"].toInt();
            foreach (Sample* sample, mSamples)
            {
                if (sample->id() == sid)
                {
                    sample->setStatus(status);
                    QJsonObject statusInfo;
                    statusInfo.insert("status", status);
                    statusInfo.insert("label", sample->statusToLabel(sample->status(), progressValue));
                    sample->setStatusUI(QVariant::fromValue(statusInfo));
                    break;
                }
            }
        }
    }
}






