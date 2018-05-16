#include "dynamicformfieldmodel.h"
#include "Model/file/fileslistmodel.h"
#include "Model/regovar.h"

DynamicFormFieldModel::DynamicFormFieldModel(DynamicFormModel* parent) : QObject(parent)
{
    mForm = parent;
}
DynamicFormFieldModel::DynamicFormFieldModel(QJsonObject json, int order, DynamicFormModel* parent) : QObject(parent)
{
    mForm = parent;
    mOrder = order;
    loadJson(json);
}


QString DynamicFormFieldModel::formatedValue() const
{
    QString result = mValue.toString();
    if (mEnumValues.count() > 0)
    {
        int idx = mValue.toInt();
        if (idx >= 0 && idx < mEnumValues.count())
        {
            result = mEnumValues[mValue.toInt()];
        }
    }
    else if (mType == "integer" || mType == "number")
    {
        result = regovar->formatNumber(mValue.toDouble());
    }
    else if (mType == "boolean")
    {
        result = mValue.toBool() ? tr("Yes") : tr("No");
    }
    return result;
}

bool DynamicFormFieldModel::loadJson(QJsonObject json)
{
    mId = json["id"].toString();
    mTitle = json["title"].toString();
    mDescription = json["description"].toString();
    mType = json["type"].toString();

    if (json.contains("enum"))
    {
        mEnumValues.clear();
        if (json["enum"].isString())
        {
            QString flag = json["enum"].toString();
            if (flag.startsWith("__") && flag.endsWith("__"))
            {
                mSpecialFlag = flag;
                refresh();
            }
        }
        else
        {
            for (const QJsonValue& value: json["enum"].toArray())
            {
                mEnumValues.append(value.toString());
            }
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
    return true;
}


bool DynamicFormFieldModel::validate()
{
    bool result = true;
    QString errorMsg;
    if (!mValue.isValid())  result = false;
    if (mValue.isNull()) result = !mRequired;
    if (!result) errorMsg = tr("Please, set a valid value for this field.");

    if (mType == "integer")
    {
        if ( mValue.type() == QVariant::String)
        {
            QString value = mValue.toString();
            value.toInt(&result);
        }
        else
        {
            result = mValue.type() == QVariant::Int || mValue.type() == QVariant::Double;
        }
        if (!result) errorMsg = tr("Thanks to set with a valid integer number.");
    }
    else if (mType == "number")
    {
        if ( mValue.type() == QVariant::String)
        {
            QString value = mValue.toString();
            value.toDouble(&result);
        }
        else
        {
            result = mValue.type() == QVariant::Double;
        }
        if (!result) errorMsg = tr("Thanks to set with a valid number.");
    }
    else if (mType == "boolean")
    {
        result = mValue.type() == QVariant::Bool;
        if (!result) errorMsg = tr("This field must be set with a boolean value: True or False.");
    }
    else if (mType == "string")
    {
        result = mValue.type() == QVariant::String;
        if (mRequired)
        {
            result = !mValue.toString().isEmpty();
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

void DynamicFormFieldModel::refresh()
{
    if (mSpecialFlag == "__INPUTS_FILES__" && mForm->inputsFiles() != nullptr)
    {
        mEnumValues.clear();
        for (int idx=0; idx < mForm->inputsFiles()->rowCount(); idx++)
        {
            mEnumValues.append(mForm->inputsFiles()->getAt(idx)->name());
        }
    }
    else if (mSpecialFlag == "__GENOMES_REFS__")
    {
        mEnumValues.clear();

        for (QObject* o: regovar->references())
        {
            Reference* ref = qobject_cast<Reference*>(o);
            mEnumValues.append(ref->name());
        }
    }
    emit dataChanged();
}

void DynamicFormFieldModel::reset()
{
    mValue = mDefaultValue;
    mInError = false;
    mErrorMessage = "";
    emit dataChanged();
}
