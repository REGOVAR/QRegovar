#include "loginwidget.h"

LoginWidget::LoginWidget(QWidget* parent) : QWidget(parent)
{
    // Set up the layout
    QFormLayout* formLayout = new QFormLayout(this);

    // Initialize form controls
    mErrorMessage = new QLabel(this);
    mErrorMessage->setMaximumWidth(300);
    mComboUsername = new QComboBox(this);
    mComboUsername->setEditable(true);
    mComboUsername->setMaximumWidth(300);
    mEditPassword = new QLineEdit(this);
    mEditPassword->setEchoMode(QLineEdit::Password);
    mEditPassword->setMaximumWidth(300);

    // Initialize buttons
    QDialogButtonBox* buttonBox;
    buttonBox = new QDialogButtonBox;
    buttonBox->setMaximumWidth(300);
    QPushButton * loginButton = buttonBox->addButton(tr("Login"), QDialogButtonBox::AcceptRole);

    // Connects Signals to other Signals
    connect(mComboUsername->lineEdit(), &QLineEdit::returnPressed, this, &LoginWidget::accepted);
    connect(mEditPassword, &QLineEdit::returnPressed, this, &LoginWidget::accepted);
    connect(loginButton, &QPushButton::clicked, this, &LoginWidget::accepted);

    // place components into the dialog
    formLayout->addWidget(mErrorMessage);
    formLayout->addRow(tr("&Username"), mComboUsername);
    formLayout->addRow(tr("&Password"), mEditPassword);
    formLayout->addWidget(buttonBox);
    formLayout->setFormAlignment(Qt::AlignCenter);
    setLayout(formLayout);
}

const QString LoginWidget::username() const
{
    return mComboUsername->currentText();
}

const QString LoginWidget::password() const
{
    return mEditPassword->text();
}

void LoginWidget::loginFailed()
{
    mErrorMessage->setText(tr("Unable to authenticate you with provided credentials"));
}

void LoginWidget::clear()
{
    mErrorMessage->setText("");
}







