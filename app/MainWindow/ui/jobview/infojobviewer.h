#ifndef INFOJOBVIEWER_H
#define INFOJOBVIEWER_H

#include <QtWidgets>
#include "ui/jobview/abstractjobviewer.h"

class InfoJobViewer : public AbstractJobViewer
{
    Q_OBJECT
public:
    InfoJobViewer(QWidget* parent=nullptr);
    void load();

private:
    QTextEdit* mName;
};

#endif // INFOJOBVIEWER_H 
