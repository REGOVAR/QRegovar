#include "joblistmodel.h"

#include "app.h"


JobListModel::JobListModel(QObject* parent) : QAbstractListModel(parent)
{
}

int JobListModel::rowCount(const QModelIndex &parent) const
{
    return mJobs.count();
}

int JobListModel::columnCount(const QModelIndex &parent) const
{
    return 4;
}

QVariant JobListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        return QVariant();
    }


    if ( role == Qt::DisplayRole)
    {
        Job job = mJobs.at(index.row());
        switch(index.column())
        {
            case NameColumn: return job.name;
            case StatusColumn:
                if (job.status == "running")
                {
                    return job.progress_label;
                }
                else
                {
                    return job.status;
                }
            case PipelineColumn:
                return job.pipelineName;
            case StartColumn:
                return job.start.toString();
        }
    }
    else if (role == Qt::DecorationRole)
    {
        Job job = mJobs.at(index.row());
        if (index.column() == StatusColumn)
        {
            if (job.status == "running") return app->awesome()->icon(fa::play);
            if (job.status == "waiting") return app->awesome()->icon(fa::pause);
            if (job.status == "error" ) return app->awesome()->icon(fa::times);
            if (job.status == "done") return app->awesome()->icon(fa::check);
        }
//        else if (index.column() == NameColumn)
//        {
//            switch (mEvents.at(index.row())->type())
//            {
//                case Info : return QFontIcon::icon(0xf017, Qt::darkGray); break;
//                case Warning: return QFontIcon::icon(0xf071,Qt::darkRed); break;
//                case Error : return QFontIcon::icon(0xf085,Qt::darkGray); break;
//                case Success: return QFontIcon::icon(0xf00c,Qt::darkGreen); break;
//            }
//        }
    }



    return QVariant();
}

QVariant JobListModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

const Job &JobListModel::job(QModelIndex index) const
{
    return mJobs.at(index.row());
}


void JobListModel::refresh()
{
    Request* request = Request::get(QString("/job"));
    connect(request, &Request::responseReceived, this, &JobListModel::updateJobs); //, [this, request](bool success, const QJsonObject& json)

}



void JobListModel::updateJobs(bool success, const QJsonObject& json)
{
    if (success)
    {
        QJsonArray data = json["data"].toArray();
        beginResetModel();
        mJobs.clear();
        for (QJsonValue item : data)
        {
            QJsonObject obj = item.toObject();
            Job job;
            job.name = obj["name"].toString();
            job.pipelineName = "";
            job.status = obj["status"].toString();
            job.progress = obj["progress_value"].toDouble();
            job.progress_label = obj["progress_label"].toString();
            job.start = QDateTime::fromString(obj["name"].toString(), Qt::ISODate);

            mJobs.append(job);
        }
        endResetModel();
    }
    else
    {
        qCritical() << Q_FUNC_INFO << "Request error occured";
    }

    Request* request = qobject_cast<Request*>(sender());
    request->deleteLater();
}
