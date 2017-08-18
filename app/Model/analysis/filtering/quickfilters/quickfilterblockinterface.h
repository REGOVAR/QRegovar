#ifndef QUICKFILTERBLOCKINTERFACE_H
#define QUICKFILTERBLOCKINTERFACE_H

#include <QVariant>
#include <QObject>


class QuickFilterField : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString op READ op WRITE setOp NOTIFY opChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(bool isActive READ isActive WRITE setIsActive NOTIFY isActiveChanged)

public:
    QuickFilterField(QString fuid="", QString op="==", QVariant value=0, bool isActive=false, QObject* parent=nullptr);
    QuickFilterField(const QuickFilterField& other);
    ~QuickFilterField();

    Q_INVOKABLE void clear();

    // Getters
    inline QString op() { return mOperator; }
    inline QVariant value() { return mValue; }
    inline bool isActive() { return mIsActive; }
    inline QString fuid() { return mFuid; }

    // Setters
    inline void setOp(QString op) { mOperator = op; emit opChanged(); }
    inline void setValue(QVariant value) { mValue = value; emit valueChanged(); }
    inline void setIsActive(bool isActive) { mIsActive = isActive; emit isActiveChanged(); }

Q_SIGNALS:
    void opChanged();
    void valueChanged();
    void isActiveChanged();

private:
    QString mFuid;
    QString mOperator;
    QString mDefaultOperator;
    QVariant mValue;
    QVariant mDefaultValue;
    bool mIsActive;
    bool mDefaultIsActive;
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


};

#endif // QUICKFILTERBLOCKINTERFACE_H
