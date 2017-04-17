#include <QLabel>
#include <QLineEdit>
#include <QCheckBox>
#include <QFormLayout>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include "myprofilewidget.h"
#include "regovar.h"

MyProfileWidget::MyProfileWidget(QWidget *parent) : QWidget(parent)
{
    mLogin = new QLabel(regovar->currentUser()->login(), this);
    mFirstname = new QLineEdit(this);
    mLastname = new QLineEdit(this);
    mFunction = new QLineEdit(this);
    mEmail = new QLineEdit(this);
    mLocation = new QLineEdit(this);
    mAvatar = new QLabel("avatar", this);

    connect(mFirstname, &QLineEdit::textChanged, this, &MyProfileWidget::onChanged);
    connect(mLastname, &QLineEdit::textChanged, this, &MyProfileWidget::onChanged);
    connect(mFunction, &QLineEdit::textChanged, this, &MyProfileWidget::onChanged);
    connect(mEmail, &QLineEdit::textChanged, this, &MyProfileWidget::onChanged);
    connect(mLocation, &QLineEdit::textChanged, this, &MyProfileWidget::onChanged);

    QFormLayout* formLayout = new QFormLayout(this);
    formLayout->addRow(tr("Firstname"), mFirstname);
    formLayout->addRow(tr("Lastname"), mLastname);
    formLayout->addRow(tr("Email"), mEmail);
    formLayout->addRow(tr("Location"), mLocation);
    formLayout->addRow(tr("Function"), mFunction);


    QVBoxLayout* leftPanel = new QVBoxLayout(this);
    leftPanel->addWidget(new QLabel("My Photo"));
    leftPanel->addWidget(new QLabel("My titles"));

    QHBoxLayout* mainLayout = new QHBoxLayout(this);
    mainLayout->addLayout(leftPanel);
    mainLayout->addLayout(formLayout);

    setLayout(mainLayout);
}


void MyProfileWidget::onChanged()
{
    mHaveChanged = true;
}

void MyProfileWidget::save()
{
    regovar->currentUser()->setFirstname(mFirstname->text());
    regovar->currentUser()->setLastname(mLastname->text());
    regovar->currentUser()->setFunction(mFunction->text());
    regovar->currentUser()->setEmail(mEmail->text());
    regovar->currentUser()->setLocation(mLocation->text());

    regovar->currentUser()->save();
}

void MyProfileWidget::reset()
{
    mFirstname->setText(regovar->currentUser()->firstname());
    mLastname->setText(regovar->currentUser()->lastname());
    mFunction->setText(regovar->currentUser()->function());
    mEmail->setText(regovar->currentUser()->email());
    mLocation->setText(regovar->currentUser()->location());
}


const bool MyProfileWidget::haveChanged() const
{
    return mHaveChanged;
}
