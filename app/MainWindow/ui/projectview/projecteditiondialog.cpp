#include "projecteditiondialog.h"
#include <QRadioButton>
#include <QGroupBox>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QLabel>

ProjectEditionDialog::ProjectEditionDialog(QWidget* parent)
    : QDialog(parent)
{
    mName = new QLineEdit;
    mComments = new QLineEdit;


    mButtonBox = new QDialogButtonBox;





    QGroupBox* policyGroupBox = buildPolicyGroupBox();


    QGroupBox* accessRightsGroupBox = buildAccessRightsGroupBox();






    QVBoxLayout* mainLayout = new QVBoxLayout;
    mainLayout->addWidget(policyGroupBox);
    mainLayout->addWidget(accessRightsGroupBox);
    mainLayout->addStretch(1);
    setLayout(mainLayout);



}


QGroupBox* ProjectEditionDialog::buildPolicyGroupBox()
{
    QGroupBox* groupBox = new QGroupBox(tr("Global sharing policy"));

    QRadioButton* radio1 = new QRadioButton(tr("&Public"));
    QRadioButton* radio2 = new QRadioButton(tr("P&rivate"));
    radio1->setStyleSheet("font-weight: bold;");
    radio2->setStyleSheet("font-weight: bold;");
    radio1->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
    radio2->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
    QLabel* explication1 = new QLabel(tr("All users can read project's data (like sample, subject, reports, results, ...). "
                                         "But they must have the \"write\" permission to be able to modify these data."));
    QLabel* explication2 = new QLabel(tr("Only public data (name, status and description) are visible by all users. "
                                          "User must have \"read\" or \"write\" access to the project to be able to access or modify project's data."));
    explication1->setWordWrap(true);
    explication2->setWordWrap(true);
    explication1->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::MinimumExpanding);
    explication2->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::MinimumExpanding);

    QVBoxLayout* r1Layout = new QVBoxLayout;
    r1Layout->addWidget(radio1);
    r1Layout->addStretch(1);
    QVBoxLayout* r2Layout = new QVBoxLayout;
    r2Layout->addWidget(radio2);
    r2Layout->addStretch(1);
    QVBoxLayout* r3Layout = new QVBoxLayout;
    r3Layout->addWidget(explication1);
    r3Layout->addStretch(1);
    QVBoxLayout* r4Layout = new QVBoxLayout;
    r4Layout->addWidget(explication2);
    r4Layout->addStretch(1);

    QGridLayout* boxLayout = new QGridLayout;
    boxLayout->addLayout(r1Layout, 1, 1);
    boxLayout->addLayout(r3Layout, 1, 2);
    boxLayout->addLayout(r2Layout, 2, 1);
    boxLayout->addLayout(r4Layout, 2, 2);
    groupBox->setLayout(boxLayout);

    // TODO set default according to user's settings
    radio1->setChecked(true);
    mPublicPolicy = true;

    return groupBox;
}


QGroupBox* ProjectEditionDialog::buildAccessRightsGroupBox()
{
    QGroupBox* groupBox = new QGroupBox(tr("Users and groups access rights"));

    mSearchBar = new QLineEdit();
    mSearchBar->setPlaceholderText(tr("Search user or group..."));

//    QAction* addReadAccess = new QAction;
//    QAction* addWriteAccess = new QAction;

    QToolButton* addUserGroupAccessButton = new QToolButton();
//    addUserGroupAccessButton->addAction(addReadAccess);
//    addUserGroupAccessButton->addAction(addWriteAccess);



    QHBoxLayout* hlayout = new QHBoxLayout;

    QRadioButton* radio1 = new QRadioButton(tr("&Public"));
    QRadioButton* radio2 = new QRadioButton(tr("P&rivate"));
    radio1->setStyleSheet("font-weight: bold;");
    radio2->setStyleSheet("font-weight: bold;");
    radio1->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
    radio2->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
    QLabel* explication1 = new QLabel(tr("All users can read project's data (like sample, subject, reports, results, ...). "
                                         "But they must have the \"write\" permission to be able to modify these data."));
    QLabel* explication2 = new QLabel(tr("Only public data (name, status and description) are visible by all users. "
                                          "User must have \"read\" or \"write\" access to the project to be able to access or modify project's data."));
    explication1->setWordWrap(true);
    explication2->setWordWrap(true);
    explication1->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::MinimumExpanding);
    explication2->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::MinimumExpanding);

    QVBoxLayout* r1Layout = new QVBoxLayout;
    r1Layout->addWidget(radio1);
    r1Layout->addStretch(1);
    QVBoxLayout* r2Layout = new QVBoxLayout;
    r2Layout->addWidget(radio2);
    r2Layout->addStretch(1);
    QVBoxLayout* r3Layout = new QVBoxLayout;
    r3Layout->addWidget(explication1);
    r3Layout->addStretch(1);
    QVBoxLayout* r4Layout = new QVBoxLayout;
    r4Layout->addWidget(explication2);
    r4Layout->addStretch(1);

    QGridLayout* boxLayout = new QGridLayout;
    boxLayout->addLayout(r1Layout, 1, 1);
    boxLayout->addLayout(r3Layout, 1, 2);
    boxLayout->addLayout(r2Layout, 2, 1);
    boxLayout->addLayout(r4Layout, 2, 2);
    groupBox->setLayout(boxLayout);

    return groupBox;
}






void ProjectEditionDialog::save()
{

}
