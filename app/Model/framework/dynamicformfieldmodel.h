#ifndef DYNAMICFORMFIELD_H
#define DYNAMICFORMFIELD_H

#include <QtCore>
#include "dynamicformmodel.h"

class DynamicFormModel;

class DynamicFormFieldModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(int order READ order NOTIFY dataChanged)
    Q_PROPERTY(QString title READ title NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)
    Q_PROPERTY(QStringList enumValues READ enumValues NOTIFY dataChanged)
    Q_PROPERTY(bool required READ required NOTIFY dataChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY dataChanged)
    Q_PROPERTY(QString formatedValue READ formatedValue NOTIFY dataChanged)
    Q_PROPERTY(QVariant defaultValue READ defaultValue NOTIFY dataChanged)
    Q_PROPERTY(DynamicFormModel* form READ form NOTIFY dataChanged)
    Q_PROPERTY(QString specialFlag READ specialFlag NOTIFY dataChanged)
    // Validation
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)
    Q_PROPERTY(bool validated READ validated NOTIFY dataChanged)
    Q_PROPERTY(bool error READ error NOTIFY dataChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY dataChanged)


public:
    // Constructor
    explicit DynamicFormFieldModel(DynamicFormModel* parent=nullptr);
    explicit DynamicFormFieldModel(QJsonObject json, int order, DynamicFormModel* parent=nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline int order() const { return mOrder; }
    inline QString title() const { return mTitle; }
    inline QString description() const { return mDescription; }
    inline QString type() const { return mType; }
    inline QStringList enumValues() const { return mEnumValues; }
    inline bool required() const { return mRequired; }
    inline QVariant value() const { return mValue; }
    inline QVariant defaultValue() const { return mDefaultValue; }
    inline bool validated() const { return mValidated; }
    inline bool error() const { return mInError; }
    inline QString errorMessage() const { return mErrorMessage; }
    inline QString searchField() const { return mSearchField; }
    inline DynamicFormModel* form() const { return mForm; }
    inline QString specialFlag() const { return mSpecialFlag; }
    QString formatedValue() const;

    // Setters
    inline void setValue(QVariant value) { mValue = value; validate(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonObject json);
    //! Check that value is valid. If not
    Q_INVOKABLE bool validate();
    //! Refresh dynamic form information withou reseting value (need for special flag that may change enum values available)
    Q_INVOKABLE void refresh();
    //! Reset field value with default value
    Q_INVOKABLE void reset();


Q_SIGNALS:
    void dataChanged();


private:
    DynamicFormModel* mForm;
    QString mId;
    int mOrder=0;
    QString mTitle;
    QString mDescription;
    QString mType;
    QStringList mEnumValues;
    bool mRequired=false;
    QVariant mValue;
    QVariant mDefaultValue;
    QString mSpecialFlag;
    bool mValidated=false;
    bool mInError=false;
    QString mErrorMessage;
    QString mSearchField;

};

#endif // DYNAMICFORMFIELD_H

