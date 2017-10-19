#include "set.h"



Set::Set(QObject* parent) : QObject(parent)
{}
Set::Set(QJsonArray json, FilteringAnalysis* parent) : QObject(parent)
{
    mAnalysis = parent;
    loadJson(json);
}
Set::Set(QString type, QString id, FilteringAnalysis* parent) : QObject(parent)
{
    mAnalysis = parent;
    QJsonArray arr;
    arr.append(type);
    arr.append(id);
    loadJson(arr);
}


void Set::loadJson(QJsonArray json)
{
    mType = json[0].toString();
    mId = json[1].toString();

    // Retrieve label for enduser display
    if (mType == "filter")
    {
        SavedFilter* filter = mAnalysis->getSavedFilter(mId.toInt());
        if (filter != nullptr)
        {
            mLabel = filter->name();
        }
        else
        {
            qDebug() << "ERROR : condition on a filter that not exists in the analysis";
        }
    }
    else if (mType == "attr")
    {
        qDebug() << "TODO : attr";
    }
    else if (mType == "sample")
    {
        Sample* sample = mAnalysis->getSampleById(mId.toInt());
        if (sample != nullptr)
        {
            mLabel = sample->nickname();
        }
        else
        {
            qDebug() << "ERROR : condition on a sample that not exists in the analysis";
        }

    }
    else if (mType == "panel")
    {
        qDebug() << "TODO : panel";
    }
    else
    {
        qDebug () << "ERROR : Unknow set filter type";
    }
    emit setChanged();
}


QJsonArray Set::toJson()
{
    QJsonArray result;
    result.append(mType);
    result.append(mId);
    return result;
}


