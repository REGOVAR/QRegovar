#include "settingsdialog.h"
#include <QDebug>
#include <QLabel.h>
#include <QPushButton>
#include <QHBoxLayout>
#include <QVBoxLayout>

#include "myprofilewidget.h"

SettingsDialog::SettingsDialog(QWidget *parent) :
    QDialog(parent)
{
    mListWidget = new QListWidget;
    mTabWidget = new QTabWidget;
    mButtonBox = new QDialogButtonBox(QDialogButtonBox::Reset|QDialogButtonBox::Ok|QDialogButtonBox::Cancel);

    mListWidget->setMaximumWidth(200);
    mListWidget->setIconSize(QSize(48,48));


    QHBoxLayout * cLayout = new QHBoxLayout;
    cLayout->addWidget(mListWidget);
    cLayout->addWidget(mTabWidget);

    QVBoxLayout * mainLayout = new QVBoxLayout;
    mainLayout->addLayout(cLayout);
    mainLayout->addWidget(mButtonBox);


    setLayout(mainLayout);


    addWidget(new MyProfileWidget(),"My profile");

    resize(800,400);

    connect(mListWidget,SIGNAL(currentRowChanged(int)),this,SLOT(updateTab(int)));
    connect(mButtonBox,SIGNAL(rejected()),this,SLOT(reject()));
    connect(mButtonBox,SIGNAL(accepted()),this,SLOT(save()));

    setWindowTitle(tr("Settings"));

    load();
}


void SettingsDialog::addWidget(AbstractSettingsWidget *widget,
                               const QString& categorie,
                               const QIcon& icon)
{
    // if categories doesn't exists, create it ! In Hash and In ListView
    if (!mWidgets.keys().contains(categorie)){
        mWidgets[categorie] = QList<AbstractSettingsWidget*>();
        mListWidget->addItem(new QListWidgetItem(icon,categorie));


    }

    mWidgets[categorie].append(widget);

}

void SettingsDialog::save()
{

    foreach (QString key, mWidgets.keys())
    {
        foreach (AbstractSettingsWidget * w, mWidgets[key])
        {
            if (!w->save())
            {
                qDebug()<<"Cannot load settings "<<w->windowTitle();
            }
        }

    }

    // App::i()->loadSettings();
    emit accept();

}

void SettingsDialog::load()
{

    foreach (QString key, mWidgets.keys())
    {
        foreach (AbstractSettingsWidget * w, mWidgets[key])
        {
            if (!w->load())
            {
                qDebug()<<"Cannot load settings "<<w->windowTitle();
            }
        }

    }
}

void SettingsDialog::updateTab(int row)
{
    Q_UNUSED(row);
    mTabWidget->clear();

    foreach ( AbstractSettingsWidget * widget , mWidgets.value(mListWidget->currentItem()->text()))
        mTabWidget->addTab(widget, widget->windowTitle());


}
