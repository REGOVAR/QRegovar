#ifndef JOBVIEW_H
#define JOBVIEW_H

#include <QtWidgets>
#include "ui/jobview/joblistmodel.h"
#include "ui/jobview/joblistview.h"

class JobView : public QTabWidget
{
    Q_OBJECT
public:
    JobView(QWidget* parent=nullptr);


private:
};

#endif // JOBVIEW_H
