#include "infojobviewer.h"

InfoJobViewer::InfoJobViewer(QWidget *parent) : AbstractJobViewer(parent)
{
    mName = new QTextEdit();
    setContent(mName);
    setWindowTitle(tr("Infos"));
}

void InfoJobViewer::load()
{
    mName->setText(job().name);
}
