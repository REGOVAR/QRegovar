#include "usereditingdialog.h"
#include <QFormLayout>
#include <QGridLayout>
#include <QVBoxLayout>
#include <QPushButton>
#include <QTime>
#include <QFileDialog>
#include "app.h"


UserEditingDialog::UserEditingDialog(UserModel* user, QWidget *parent) : QDialog(parent)
{
    QTime time = QTime::currentTime();
    qsrand((uint)time.msec());

    mUser = user;
    if (mUser == nullptr)
    {
        mUser = new UserModel;
    }

    mLogin = new QLineEdit(mUser->login());
    mPassword = new QLineEdit();
    mFirstname = new QLineEdit(mUser->firstname());
    mLastname = new QLineEdit(mUser->lastname());
    mFunction = new QLineEdit(mUser->function());
    mEmail = new QLineEdit(mUser->email());
    mLocation = new QLineEdit(mUser->location());
    mAvatar = new QLabel();
    mAvatar->setMaximumSize(100, 100);
    mLogin->setPlaceholderText(tr("Unique user's login"));
    mPassword->setPlaceholderText(tr("Set/Reset user's password"));
    mEmail->setPlaceholderText(tr("Unique user's email"));

    // TODO : set pixmap from model if exists
    QPixmap img;
    img.load("https://en.opensuse.org/images/0/0b/Icon-user.png");
    mAvatar->setPixmap(img);

    mButtonBox = new QDialogButtonBox(QDialogButtonBox::Cancel|QDialogButtonBox::Save);
    QPushButton* randomPassword = new QPushButton(tr("Generate Password"));
    QPushButton* selectAvatar = new QPushButton(tr("Select avatar"));

    QLabel* securityIcon = new QLabel;
    securityIcon->setPixmap(app->awesome()->icon(fa::lock).pixmap(64, 64));

    connect(mLogin, &QLineEdit::textChanged, this, &UserEditingDialog::checkLogin);
    connect(mEmail, &QLineEdit::textChanged, this, &UserEditingDialog::checkEmail);
    connect(mButtonBox, &QDialogButtonBox::accepted, this, &UserEditingDialog::save);
    connect(mButtonBox, &QDialogButtonBox::rejected, this, &UserEditingDialog::reject);
    connect(randomPassword, &QPushButton::clicked, this, &UserEditingDialog::randomPassword);
    connect(selectAvatar, &QPushButton::clicked, this, &UserEditingDialog::selectAvatar);

    QWidget* separator = new QWidget(this);
    separator->setMinimumHeight(30);
    QWidget* stretcher = new QWidget(this);
    stretcher->setSizePolicy(QSizePolicy::Preferred,QSizePolicy::Expanding);

    QFormLayout* credentialLayout = new QFormLayout();
    credentialLayout->addRow(tr("Login *"), mLogin);
    credentialLayout->addRow(tr("Password"), mPassword);
    credentialLayout->addWidget(randomPassword);

    QFormLayout* formLayout = new QFormLayout();
    formLayout->addRow(tr("Firstname"), mFirstname);
    formLayout->addRow(tr("Lastname"), mLastname);
    formLayout->addRow(tr("Email"), mEmail);
    formLayout->addRow(tr("Location"), mLocation);
    formLayout->addRow(tr("Function"), mFunction);

    QVBoxLayout* avatarPanel = new QVBoxLayout();
    avatarPanel->addWidget(mAvatar);
    avatarPanel->addWidget(selectAvatar);
    avatarPanel->addWidget(stretcher);


    QGridLayout* mainLayout = new QGridLayout();
    mainLayout->addWidget(securityIcon, 1, 1);
    mainLayout->addLayout(credentialLayout, 1, 2);
    mainLayout->addWidget(separator,2,1,1,2);
    mainLayout->addLayout(avatarPanel, 3, 1);
    mainLayout->addLayout(formLayout, 3, 2);
    mainLayout->addWidget(mButtonBox, 4, 1, 1, 2);

    setLayout(mainLayout);
    resize(500,400);

    setWindowTitle(mUser->id() != 0 ? tr("Edit user") : tr("New user"));
}


void UserEditingDialog::save()
{
    // Todo query to save or edit the user
    mUser->setLogin(mLogin->text());
    if (!mPassword->text().isEmpty())
    {
        mUser->setPassword(mPassword->text());
    }
    mUser->setFirstname(mFirstname->text());
    mUser->setLastname(mLastname->text());
    mUser->setEmail(mEmail->text());
    mUser->setFunction(mFunction->text());
    mUser->setLocation(mLocation->text());
    mUser->save();



    // App::i()->loadSettings();
    emit accept();
}

void UserEditingDialog::checkLogin()
{
    // check that login is unique

}

void UserEditingDialog::checkEmail()
{
    // check that email is unique
}


void UserEditingDialog::randomPassword()
{
    QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789?!$*#");
    int randomStringLength = 12;

    QString randomString;
    for(int i=0; i<randomStringLength; ++i)
    {
       int index = qrand() % possibleCharacters.length();
       QChar nextChar = possibleCharacters.at(index);
       randomString.append(nextChar);
    }
    mPassword->setText(randomString);
}


void UserEditingDialog::selectAvatar()
{
    QPixmap img;
    QString path = QFileDialog::getOpenFileName(this, tr("Avatar's image file"), QDir::currentPath(), tr("*.jpg *.png"));
    img.load(path);
    mUser->setAvatar(img);
    mAvatar->setPixmap(QPixmap(path));
}
