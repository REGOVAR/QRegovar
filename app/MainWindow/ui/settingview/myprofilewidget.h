#ifndef MYPROFILEWIDGET_H
#define MYPROFILEWIDGET_H

#include <QWidget>
#include <QLabel>
#include <QLineEdit>
#include <QPixmap>

class MyProfileWidget : public QWidget
{
    Q_OBJECT
public:
    explicit MyProfileWidget(QWidget *parent = 0);


    const bool haveChanged() const;



public Q_SLOTS:
    void onChanged();
    void save();
    void reset();

private:
    QLabel* mLogin;
    QLineEdit* mFirstname;
    QLineEdit* mLastname;
    QLineEdit* mFunction;
    QLineEdit* mEmail;
    QLineEdit* mLocation;
    QLabel* mAvatar;

    bool mHaveChanged=false;
};

#endif // MYPROFILEWIDGET_H
