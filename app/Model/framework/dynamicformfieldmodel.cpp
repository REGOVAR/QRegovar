#include "dynamicformfieldmodel.h"

DynamicFormFieldModel::DynamicFormFieldModel(DynamicFormModel* parent) : QObject(parent)
{
    mForm = parent;
}
DynamicFormFieldModel::DynamicFormFieldModel(QJsonObject json, int order, DynamicFormModel* parent) : QObject(parent)
{
    mForm = parent;
    mOrder = order;
    fromJson(json);
}


bool DynamicFormFieldModel::fromJson(QJsonObject json)
{
    mId = json["id"].toString();
    mTitle = json["title"].toString();
    mDescription = json["description"].toString();
    mType = json["type"].toString();

    if (json.contains("enum"))
    {
        mEnumValues.clear();
        for (const QJsonValue& value: json["enum"].toArray())
        {
            mEnumValues.append(value.toString());
        }
    }
    if (json.contains("required"))
    {
        mRequired = json["required"].toBool();
    }


    if (mType == "string")
    {
        mDefaultValue = "";
    }
    if (mEnumValues.count() > 0)
    {
        mDefaultValue = 0;
    }

    if (json.contains("default"))
    {
        mDefaultValue = json["default"].toVariant();
    }
    reset();
}


bool DynamicFormFieldModel::validate()
{
    bool result = true;
    QString errorMsg;
    if (!mValue.isValid())  result = false;
    if (mValue.isNull()) result = !mRequired;
    if (!result) errorMsg = tr("Please, set a valid value for this field.");

    QVariant valueToTest = mValue;
    if (mEnumValues.count() > 0)
    {
        valueToTest = mEnumValues[mValue.toInt()];
    }


    if (mType == "integer")
    {
        if ( valueToTest.type() == QVariant::String)
        {
            QString value = valueToTest.toString();
            value.toInt(&result);
        }
        else
        {
            result = valueToTest.type() == QVariant::Int || valueToTest.type() == QVariant::Double;
        }
        if (!result) errorMsg = tr("Thanks to set with a valid integer number.");
    }
    else if (mType == "number")
    {
        if ( valueToTest.type() == QVariant::String)
        {
            QString value = valueToTest.toString();
            value.toDouble(&result);
        }
        else
        {
            result = valueToTest.type() == QVariant::Double;
        }
        if (!result) errorMsg = tr("Thanks to set with a valid number.");
    }
    else if (mType == "boolean")
    {
        result = valueToTest.type() == QVariant::Bool;
        if (!result) errorMsg = tr("This field must be set with a boolean value: True or False.");
    }
    else if (mType == "string")
    {
        result = valueToTest.type() == QVariant::String;
        if (mRequired)
        {
            result = !valueToTest.toString().isEmpty();
        }
        if (!result) errorMsg = tr("This field must be set with a string value.");
    }

    if (!result)
    {
        mInError = true;
        mErrorMessage = errorMsg;
    }
    else
    {
        mInError = false;
        mErrorMessage = "";
    }
    emit dataChanged();
    return result;
}


void DynamicFormFieldModel::reset()
{
    mValue = mDefaultValue;
    mInError = false;
    mErrorMessage = "";
    emit dataChanged();
}
