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
    buttonBox->addButton(tr("Login"), QDialogButtonBox::AcceptRole);

    // Connects slots
    connect(buttonBox, &QDialogButtonBox::accepted, this, &LoginWidget::accept);

    // place components into the dialog
    formLayout->addRow(tr("&Username"), mComboUsername);
    formLayout->addRow(tr("&Password"), mEditPassword);
    formLayout->addWidget(buttonBox);
    formLayout->setFormAlignment(Qt::AlignCenter);
    setLayout(formLayout);
}






void LoginWidget::accept()
{
    QString username = mComboUsername->currentText();
    QString password = mEditPassword->text();
    emit login(username, password);
}





