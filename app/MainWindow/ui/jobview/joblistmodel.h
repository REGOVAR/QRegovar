#ifndef JOBLISTMODEL_H
#define JOBLISTMODEL_H

#include <QtCore>
#include "tools/request.h"

struct Job
{
    QString name;
    double progress;
    QString progress_label;
    QString status;
    QString pipelineName;
    QDateTime start;
};


class JobListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum
    {
        NameColumn = 0,
        StatusColumn,
        PipelineColumn,
        StartColumn
    };




    JobListModel(QObject* parent=nullptr);


    int rowCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    int columnCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const Q_DECL_OVERRIDE;

    const Job& job(QModelIndex index) const;

public Q_SLOTS:
    void refresh();

protected Q_SLOTS:
    void updateJobs(bool success, const QJsonObject& json);


private:
    QList<Job> mJobs;
    Request* mRequest;
};

#endif // JOBLISTMODEL_H
