#include "filteringanalysis.h"

#include "Model/request.h"
#include "Model/regovar.h"

FilteringAnalysis::FilteringAnalysis(QObject *parent) : Analysis(parent)
{
    // Tree model are created to allow QML binding initialisation even if no data loaded
    mType = tr("Variants Filtering");
    mResults = new ResultsTreeModel(this);
    mAllAnnotationsTreeModel = new AnnotationsTreeModel(this);
    mAnnotationsTreeModel = new AnnotationsTreeModel(this);
    mQuickFilters = new QuickFilterModel(this);
    mLoadingStatus = empty;


    connect(this, SIGNAL(loadingStatusChanged(LoadingStatus,LoadingStatus)),
            this, SLOT(asynchLoading(LoadingStatus,LoadingStatus)));
}


bool FilteringAnalysis::fromJson(QJsonObject json)
{
    // load basic data from json
    // TODO
    setId(json["id"].toInt());
    setName(json["name"].toString());
    setComment(json["comment"].toString());
    setType("Dynamic filtering analysis");
    setLastUpdate(QDateTime::fromString(json["update_date"].toString(), Qt::ISODate));
    mRefId = json["reference_id"].toInt();
    mRefName = json["ref_name"].toString();
    mStatus = json["status"].toString();

    // Parse settings
    QJsonObject settings = json["settings"].toObject();
    foreach (const QJsonValue field, settings["annotations_db"].toArray())
    {
        mAnnotationsDBUsed << field.toString();
    }
//    bool mIsTrio = ;
//    int mTrioChild;
//    int mTrioMother;
//    int mTrioFather;

    // Retrieve samples
    mSamples.clear();
    foreach (const QJsonValue field, json["samples_ids"].toArray())
    {
        int id = field.toInt();
        mSamples.append(new Sample(id, QString("Sample n°%1").arg(id), "", this));
    }
    emit samplesUpdated();

    // Retrieve fields
    foreach (const QJsonValue field, json["fields"].toArray())
    {
        QString uid = field.toString();
        mFields << uid;
        qDebug() << " - " << uid;
    }

    // Retrieve filter
    QJsonDocument doc;
    doc.setArray(json["filter"].toArray());
    mFilter = QString(doc.toJson(QJsonDocument::Indented));


    mResults->initAnalysisData(mId);
    mQuickFilters->init(mRefId, mId);

    // Loading of an analysis required 2 steps
    // first : need to load alls annotations available accdording to the referencial and
    // then : need to load result (annotation must be already loaded)
    // Chaining of loading step is done thanks to signals (see asynchLoading slot)
    emit loadingStatusChanged(mLoadingStatus, loadingAnnotations);
    mLoadingStatus = loadingAnnotations;

    return true;
}




void FilteringAnalysis::asynchLoading(LoadingStatus oldSatus, LoadingStatus newStatus)
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
    Request* req = Request::get(QString("/annotation/%1").arg(mRefId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "LOAD ANNOT START : ";
            QJsonObject data = json["data"].toObject();
            mRefId = data["ref_id"].toInt();
            mRefName = data["ref_name"].toString();

            // Init list of displayed columns according to analysis settings
            mAnnotations.clear();
            mAnnotations.insert("_RowHead", new FieldColumnInfos(nullptr, true, 0, "", this));
            mAnnotations.insert("_Samples", new FieldColumnInfos(nullptr, false, -1, "", this));
            mAnnotations["_RowHead"]->setRole(FieldColumnInfos::RowHeader);
            mAnnotations["_Samples"]->setRole(FieldColumnInfos::SamplesNames);

            foreach (const QJsonValue dbv, data["db"].toArray())
            {
                QJsonObject db = dbv.toObject();

                QString dbName = db["name"].toString();
                QString dbDescription = db["description"].toString();
                QJsonObject dbVersion = db["versions"].toObject();



                qDebug() << "  DB:" << dbName;
                // Foreach available version of annotation database
                foreach (const QString dbVersionName, dbVersion.keys())
                {
                    QString dbUid = dbVersion[dbVersionName].toString();
                    bool isDbSelected = (mAnnotationsDBUsed.contains(dbUid) || (dbName == "Variant" && dbVersionName=="_regovar_"));

                    qDebug() << "  Version:" << dbVersionName << isDbSelected;
                    // Build annotation and column infos
                    foreach(const QJsonValue json, db["fields"].toArray())
                    {
                        QJsonObject a = json.toObject();

                        QString uid = a["uid"].toString();
                        QString dbUid = a["dbuid"].toString();
                        QString name = a["name"].toString();
                        QString description = a["description"].toString();
                        QString type = a["type"].toString();
                        QJsonObject meta = a["meta"].toObject();

                        qDebug() << "   - " << uid << name;

                        Annotation* annot = new Annotation(this, uid, dbUid, name, description, type, meta, "");
                        FieldColumnInfos* fInfo = new FieldColumnInfos(annot, mFields.contains(uid), mFields.indexOf(uid), "", this);
                        mAnnotations.insert(uid, fInfo);

                        // add annotation to the "All annotation" treeModel
                        mAllAnnotationsTreeModel->addEntry(dbName, dbVersionName, dbDescription, isDbSelected, mAnnotations[uid]);
                        if (isDbSelected || dbVersionName == "_regovar_")
                        {
                            // add annotation to the treeModel of annotation available for this analysis
                            mAnnotationsTreeModel->addEntry(dbName, dbVersionName, dbDescription, isDbSelected, mAnnotations[uid]);
                        }
                    }
                }
            }

            refreshDisplayedAnnotationColumns();
            qDebug() << "Filtering analysis init : annotations data loaded";
            emit loadingStatusChanged(mLoadingStatus, LoadingResults);
            mLoadingStatus = LoadingResults;
        }
        else
        {
            regovar->error(json);
            emit loadingStatusChanged(mLoadingStatus, error);
            mLoadingStatus = error;
        }
        req->deleteLater();
    });
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


QStringList FilteringAnalysis::displayedSamples()
{
    QStringList result;
    foreach (Sample* sp, mSamples)
    {
        result << sp->name();
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
                qDebug() << "Filtering analysis init : results loaded";
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
            regovar->error(json);
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


    emit fieldsUpdated();

    // Update columns to display in the QML view according to selected annoations
    refreshDisplayedAnnotationColumns();
    return order;
}








