#include "loginwidget.h"

LoginWidget::LoginWidget(QWidget *parent) : QWidget(parent)
{
    // Set up the layout
    QGridLayout *formGridLayout = new QGridLayout( this );

    // Initialize the username combo box so that it is editable
    mComboUsername = new QComboBox(this);
    mComboUsername->setEditable(true);
    // initialize the password field so that it does not echo characters
    mEditPassword = new QLineEdit(this);
    mEditPassword->setEchoMode(QLineEdit::Password);

    // initialize the labels
    mLabelUsername = new QLabel(this);
    mLabelPassword = new QLabel(this);
    mLabelUsername->setText(tr("Username"));
    mLabelUsername->setBuddy(mComboUsername);
    mLabelPassword->setText(tr("Password"));
    mLabelPassword->setBuddy(mEditPassword);

    // initialize buttons
    mButtons = new QDialogButtonBox(this);
    mButtons->addButton(QDialogButtonBox::Ok);
    mButtons->addButton(QDialogButtonBox::Cancel);
    mButtons->button(QDialogButtonBox::Ok)->setText(tr("Login"));

    // connects slots
    connect(mButtons->button(QDialogButtonBox::Ok), SIGNAL(clicked()), this, SLOT(slotAcceptLogin()));

    // place components into the dialog
    formGridLayout->setAlignment(Qt::AlignCenter);
    formGridLayout->addWidget(mLabelUsername, 0, 0);
    formGridLayout->addWidget(mComboUsername, 0, 1);
    formGridLayout->addWidget(mLabelPassword, 1, 0);
    formGridLayout->addWidget(mEditPassword, 1, 1);
    formGridLayout->addWidget(mButtons, 2, 0, 1, 2);

    setLayout(formGridLayout);

    resize(200,300);
}





void LoginWidget::setUsername(QString &username)
{
    bool found = false;
    for( int i = 0; i < mComboUsername->count() && ! found ; i++ )
    if( mComboUsername->itemText( i ) == username )
    {
        mComboUsername->setCurrentIndex( i );
        found = true;
    }

    if( ! found )
    {
        int index = mComboUsername->count();
        qDebug() << "Select username " << index;
        mComboUsername->addItem( username );
        mComboUsername->setCurrentIndex( index );
    }

    // place the focus on the password field
    mEditPassword->setFocus();
}

void LoginWidget::setPassword(QString &password)
{
    mEditPassword->setText( password );
}

void LoginWidget::slotAcceptLogin()
{
    QString username = mComboUsername->currentText();
    QString password = mEditPassword->text();
    int index = mComboUsername->currentIndex();

    emit acceptLogin( username, // current username
    password, // current password
    index // index in the username list
    );

    // close this dialog
    close();
}

void LoginWidget::setUsernamesList(const QStringList &usernames)
{
    mComboUsername->addItems( usernames );
}




