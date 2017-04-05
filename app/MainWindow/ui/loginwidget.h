#ifndef LOGINWIDGET_H
#define LOGINWIDGET_H

#include <QWidget>
#include <QLabel>
#include <QPushButton>
#include <QDialogButtonBox>
#include <QLineEdit>
#include <QComboBox>
#include <QFormLayout>
#include <QStringList>
#include <QDebug>

class LoginWidget : public QWidget
{
    Q_OBJECT
private:
    QComboBox* mComboUsername;
    QLineEdit* mEditPassword;


public:
    explicit LoginWidget(QWidget* parent = 0);


Q_SIGNALS:
    void login(QString& username, QString& password);


public Q_SLOTS:
    void accept();
};

#endif // LOGINWIDGET_H
