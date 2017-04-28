#ifndef PROJECTEDITIONDIALOG_H
#define PROJECTEDITIONDIALOG_H

#include <QDialog>
#include <QLineEdit>
#include <QDialogButtonBox>
#include <QGroupBox>
#include <QToolButton>

class ProjectEditionDialog : public QDialog
{
    Q_OBJECT
public:
    ProjectEditionDialog(QWidget* parent=0);


    QGroupBox* buildPolicyGroupBox();
    QGroupBox* buildAccessRightsGroupBox();

public Q_SLOTS:
    void save();


private:
    QLineEdit* mName;
    QLineEdit* mComments;
    QLineEdit* mSearchBar;
    QToolButton* addUserGroupAccessButton;

    bool mPublicPolicy;



    QDialogButtonBox* mButtonBox;
};

#endif // PROJECTEDITIONDIALOG_H
