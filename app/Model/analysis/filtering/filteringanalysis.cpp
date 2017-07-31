#include "filteringanalysis.h"

#include "Model/request.h"
#include "Model/regovar.h"

FilteringAnalysis::FilteringAnalysis(QObject *parent) : Analysis(parent)
{
    // Tree model are created to allow QML binding initialisation even if no data loaded
    mType = tr("Variants Filtering");
    mResults = new ResultsTreeModel(this);
    mAnnotations = new AnnotationsTreeModel(this);
    mQuickFilters = new QuickFilterModel(this);
    mUIStatus = empty;
}


bool FilteringAnalysis::fromJson(QJsonObject json)
{
    // load basic data from json
    // TODO
    mId = json["id"].toInt();
    mName = json["name"].toString();
    mRefId = json["ref_id"].toInt();
    mRefName = json["ref_name"].toString();

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
    // Chaining of loading step is done thanks to signals
    connect(this, SIGNAL(statusChanged(LoadingStatus,LoadingStatus)),
            this, SLOT(asynchLoading(LoadingStatus,LoadingStatus)));
    emit statusChanged(empty, loadingAnnotations);
    mUIStatus = loadingAnnotations;

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
            if (mAnnotations->fromJson(json["data"].toObject()))
            {
                qDebug() << "Filtering analysis init : annotations data loaded";
                emit statusChanged(mUIStatus, LoadingResults);
                mUIStatus = LoadingResults;
            }
            else
            {
                qDebug() << "Filtering analysis init : Failed to load annotation data for" << mRefName << mRefId << "reference";
                emit statusChanged(mUIStatus, error);
                mUIStatus = error;
            }
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "Request error ! " << json["msg"].toString();
            emit statusChanged(mUIStatus, error);
            mUIStatus = error;
        }
        req->deleteLater();
    });
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
                emit statusChanged(mUIStatus, ready);
                mUIStatus = ready;
            }
            else
            {
                qDebug() << "Filtering analysis init : Failed to load result";
                emit statusChanged(mUIStatus, error);
                mUIStatus = error;
            }
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "Request error ! " << json["msg"].toString();
            emit statusChanged(mUIStatus, error);
            mUIStatus = error;
        }
        req->deleteLater();
    });
}




//! Add or remove a field to the display result and update or set the order
//! Return the order of the field in the grid
int FilteringAnalysis::setField(QString uid, bool isDisplayed, int order)
{
    Annotation* annot = regovar->currentFilteringAnalysis()->annotations()->getAnnotation(uid);

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
    emit fieldsUpdated();
    return order;
}








