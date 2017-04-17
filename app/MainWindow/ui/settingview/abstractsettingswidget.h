#ifndef ABSTRACTSETTINGSWIDGET_H
#define ABSTRACTSETTINGSWIDGET_H

#include <QWidget>
#include <QTabWidget>

class AbstractSettingsWidget : public QWidget
{
    Q_OBJECT
public:
    explicit AbstractSettingsWidget(QWidget *parent = 0);

public Q_SLOTS:
    virtual bool save() = 0;
    virtual bool load() = 0;


};



#endif // ABSTRACTSETTINGSWIDGET_H
