#ifndef SETTINGSWIDGET_H
#define SETTINGSWIDGET_H

#include <QDialog>
#include <QStackedWidget>
#include <QListWidget>
#include "myprofilewidget.h"

class SettingsWidget : public QDialog
{
    Q_OBJECT
public:
    explicit SettingsWidget(QWidget* parent=0);


signals:

public slots:

private:
    QStackedWidget* mStackedWidget;
    QListWidget* mListWidget;
    MyProfileWidget* mMyProfileWidget;
};

#endif // SETTINGSWIDGET_H
