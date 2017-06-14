#include "abstractjobviewer.h"

AbstractJobViewer::AbstractJobViewer(QWidget *parent) : QWidget(parent)
{

}


const Job& AbstractJobViewer::job() const
{
    return mJob;
}

void AbstractJobViewer::setJob(const Job &job)
{
    mJob = job;
    load();
}

void AbstractJobViewer::setContent(QWidget *content)
{
    QVBoxLayout* layout = new QVBoxLayout();
    layout->addWidget(content);

    setLayout(layout);
    setContentsMargins(0,0,0,0);
}
