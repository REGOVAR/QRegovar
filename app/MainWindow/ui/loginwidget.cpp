#include "loginwidget.h"

LoginWidget::LoginWidget(QWidget* parent) : QWidget(parent)
{
    // Set up the layout
    QFormLayout* formLayout = new QFormLayout(this);

    // Initialize form controls
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
    connect(loginButton, &QPushButton::clicked, this, &LoginWidget::accepted);

    // place components into the dialog
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










