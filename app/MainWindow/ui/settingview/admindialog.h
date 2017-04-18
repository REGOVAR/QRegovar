#ifndef ADMINDIALOG_H
#define ADMINDIALOG_H


#include <QWidget>
#include <QDialog>
#include <QHBoxLayout>
#include <QList>
#include <QStackedWidget>
#include <QListWidget>
#include <QDialogButtonBox>
#include "abstractsettingswidget.h"


class AdminDialog : public QDialog
{
    Q_OBJECT
public:
    explicit AdminDialog(QWidget *parent = 0);
    void addWidget(AbstractSettingsWidget * widget,
                   const QString& categorie = QString("extra"),
                   const QIcon& icon = QIcon());

public Q_SLOTS:
    void save();
    void load();

protected Q_SLOTS:
    void updateTab(int row);

private:

private:
    QHash<QString, QList<AbstractSettingsWidget*> > mWidgets;

    QStackedWidget * mStackedWidget;
    QListWidget * mListWidget;
    QDialogButtonBox * mButtonBox;

};

#endif // ADMINDIALOG_H
