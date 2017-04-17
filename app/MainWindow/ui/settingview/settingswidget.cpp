#include "settingswidget.h"
#include <QLabel.h>
#include <QPushButton>
#include <QHBoxLayout>
#include <QVBoxLayout>

SettingsWidget::SettingsWidget(QWidget *parent) : QDialog(parent)
{
    mStackedWidget = new QStackedWidget(this);
    mListWidget = new QListWidget(this);
    mMyProfileWidget = new MyProfileWidget(this);

    mListWidget->addItem(tr("My profile"));
    mListWidget->setMaximumWidth(200);
    mStackedWidget->addWidget(mMyProfileWidget);


    QLabel* text = new QLabel("Settings widget");
    QHBoxLayout* contentLayout = new QHBoxLayout(this);
    contentLayout->addWidget(mListWidget);
    contentLayout->addWidget(mStackedWidget);
    setLayout(contentLayout);

    QWidget* stretcher = new QWidget(this);
    stretcher->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Preferred);

    QPushButton* cancelButton = new QPushButton(this);
    cancelButton->setText(tr("Cancel"));
    QPushButton* saveButton = new QPushButton(this);
    saveButton->setText(tr("Save"));


    QHBoxLayout* buttonLayout = new QHBoxLayout(this);
    buttonLayout->addWidget(stretcher);
    buttonLayout->addWidget(cancelButton);
    buttonLayout->addWidget(saveButton);


    QVBoxLayout* mainLayout = new QVBoxLayout(this);
    mainLayout->addLayout(contentLayout);
    mainLayout->addLayout(buttonLayout);

    setWindowTitle(tr("Settings"));
    resize(QSize(500,400));
}

