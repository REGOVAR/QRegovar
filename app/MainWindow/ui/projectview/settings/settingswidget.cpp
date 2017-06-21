#include <QLabel>
#include <QLineEdit>
#include <QCheckBox>
#include <QFormLayout>
#include <QHBoxLayout>
#include <QVBoxLayout>

#include "settingswidget.h"
#include "regovar.h"

namespace projectview
{


SettingsWidget::SettingsWidget(QWidget *parent)
{
    mTabWidget = new QTabWidget(this);
    QWidget* informationsTab = new QWidget(this);
    QWidget* indicatorsTab = new QWidget(this);
    QWidget* shareTab = new QWidget(this);

    mTabWidget->addTab(informationsTab, tr("Informations"));
    mTabWidget->addTab(indicatorsTab, tr("Indicators"));
    mTabWidget->addTab(shareTab, tr("Share"));






    QVBoxLayout* mainLayout = new QVBoxLayout();
    mainLayout->setContentsMargins(0,0,0,0);
    mainLayout->addWidget(mTabWidget);

    setLayout(mainLayout);
}


bool SettingsWidget::save()
{
    return true;
}

bool SettingsWidget::load()
{
    return true;
}

void SettingsWidget::onChanged()
{
    mHaveChanged = true;
}



const bool SettingsWidget::haveChanged() const
{
    return mHaveChanged;
}


} // END namespace projectview
