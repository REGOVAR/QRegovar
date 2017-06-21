#ifndef SETTINGSEWIDGET_H
#define SETTINGSEWIDGET_H

#include <QWidget>
#include <QLabel>
#include <QLineEdit>
#include <QTabWidget>



namespace projectview
{


class SettingsWidget : public QWidget
{
    Q_OBJECT
public:
    SettingsWidget(QWidget *parent = 0);


    const bool haveChanged() const;



public Q_SLOTS:
    bool save();
    bool load();
    void onChanged();

private:
    QTabWidget* mTabWidget;

    QLineEdit* mName;
    QLineEdit* mComment;
    QLineEdit* mIndicator;
    QLineEdit* mSharing;


    bool mHaveChanged=false;
};

} // END namespace projectview

#endif // SETTINGSEWIDGET_H
