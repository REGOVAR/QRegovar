#ifndef ABSTRACTJOBVIEWER_H
#define ABSTRACTJOBVIEWER_H

#include <QtWidgets>
#include "ui/jobview/joblistmodel.h"

class AbstractJobViewer : public QWidget
{
    Q_OBJECT
public:
    explicit AbstractJobViewer(QWidget *parent = 0);

    const Job& job() const;
    void setJob(const Job &job);
    virtual void load() = 0;
    void setContent(QWidget* content);

signals:

public slots:

private:
    Job mJob;
};

#endif // ABSTRACTJOBVIEWER_H
