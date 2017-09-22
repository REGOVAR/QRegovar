#ifndef QUICKFILTERBLOCKINTERFACE_H
#define QUICKFILTERBLOCKINTERFACE_H

#include <QVariant>
#include <QObject>
#include "../annotation.h"


class QuickFilterField : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString label READ label WRITE setLabel NOTIFY labelChanged)
    Q_PROPERTY(QString op READ op WRITE setOp NOTIFY opChanged)
    Q_PROPERTY(QStringList opList READ opList)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(bool isActive READ isActive WRITE setIsActive NOTIFY isActiveChanged)
    Q_PROPERTY(bool isDisplayed READ isDisplayed WRITE setIsDisplayed NOTIFY isDisplayedChanged)

public:
    QuickFilterField(QObject* parent=nullptr);
    QuickFilterField(QString fuid, QString label, QStringList opList, QString op="==", QVariant value=0, bool isActive=false, QObject* parent=nullptr);
    QuickFilterField(const QuickFilterField& other);
    ~QuickFilterField();

    Q_INVOKABLE void clear();

    // Getters
    inline QString label() { return mLabel; }
    inline QString op() { return mOperator; }
    inline QStringList opList() { return mOperatorsValues; }
    inline QVariant value() { return mValue; }
    inline bool isActive() { return mIsActive; }
    inline bool isDisplayed() { return mIsDisplayed; }
    inline QString fuid() { return mFuid; }

    // Setters
    inline void setLabel(QString label) { if (label != mLabel) { mLabel= label;  emit labelChanged(); }}
    inline void setOp(QString op) { if (op != mOperator) { mOperator = op;  emit opChanged(); }}
    inline void setValue(QVariant value) { if (value != mValue) { mValue = value; emit valueChanged(); }}
    inline void setIsActive(bool isActive) { if (isActive != mIsActive) { mIsActive = isActive; emit isActiveChanged(); }}
    inline void setIsDisplayed(bool isDisplayed) { if (isDisplayed != mIsDisplayed) { mIsDisplayed = isDisplayed; emit isDisplayedChanged(); }}

Q_SIGNALS:
    void labelChanged();
    void opChanged();
    void valueChanged();
    void isActiveChanged();
    void isDisplayedChanged();

private:
    QString mFuid;
    QString mLabel;
    QString mOperator;
    QString mDefaultOperator;
    QStringList mOperatorsValues;
    QVariant mValue;
    QVariant mDefaultValue;
    bool mIsActive;
    bool mDefaultIsActive;
    bool mIsDisplayed;
};




class QuickFilterBlockInterface : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isVisible READ isVisible)

public:
    explicit QuickFilterBlockInterface(QObject *parent = nullptr);


    //! Indicates if this filter shall be displayed in the UI (by example some filter are only for "Trio analysis")
    Q_INVOKABLE virtual bool isVisible() = 0;
    //! Return the filter query as Json string that will be concatened with other quickFilters
    Q_INVOKABLE virtual QString getFilter() = 0;
    //! Generic method to set value of the filter thanks to the UI.
    Q_INVOKABLE virtual void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant()) = 0;
    //! Reset the filter
    Q_INVOKABLE virtual void clear() = 0;
    //!
    Q_INVOKABLE virtual void checkAnnotationsDB(QList<QObject*> dbs) = 0;
    //! Init the filter with the provided json formated filter (load from server)
    virtual bool loadFilter(QJsonArray filter) = 0;




};

#endif // QUICKFILTERBLOCKINTERFACE_H
