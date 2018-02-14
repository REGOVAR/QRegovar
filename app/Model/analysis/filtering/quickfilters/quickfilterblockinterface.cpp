#include "quickfilterblockinterface.h"

// Init static variable
QHash<QString, QString> QuickFilterField::mOpMapping = QuickFilterField::initOpMapping();
QHash<QString, QString> QuickFilterField::initOpMapping()
{
    QHash<QString, QString> map;
    map.insert("<", "<");
    map.insert("≤", "<=");
    map.insert("=", "==");
    map.insert("≥", ">=");
    map.insert(">", ">");
    map.insert("≠", "!=");
    return map;
}


QuickFilterField::QuickFilterField(QObject* parent) : QObject(parent)
{
    mIsDisplayed = false;
    mIsActive = false;
}

QuickFilterField::QuickFilterField(QString fuid, QString label, QStringList opList, QString op, QVariant value, bool isActive, QObject* parent)
    : QObject(parent)
{
    mIsDisplayed = true;
    mFuid = fuid;
    mLabel = label;
    mOperator = op;
    mOperatorsValues = opList;
    mDefaultOperator = op;
    mValue = value;
    mDefaultValue = value;
    mIsActive = isActive;
    mDefaultIsActive = isActive;

}





void QuickFilterField::clear()
{
    mOperator = mDefaultOperator;
    mValue = mDefaultValue;
    mIsActive = mDefaultIsActive;
    emit dataChanged();
}

QJsonArray QuickFilterField::toJson()
{
    QJsonArray opLeft;
    opLeft.append("field");
    opLeft.append(mFuid);
    QJsonArray opRight;
    opRight.append("value");
    opRight.append(mValue.toString());

    QJsonArray result;
    result.append(mOpMapping.contains(mOperator) ? mOpMapping[mOperator] : "==");
    result.append(opLeft);
    result.append(opRight);
    return result;
}



void QuickFilterField::setOp(QString op)
{
    if (op != mOperator && mOpMapping.contains(op))
    {
        mOperator = op;
        emit dataChanged();
    }
}




QuickFilterBlockInterface::QuickFilterBlockInterface(QObject *parent) : QObject(parent)
{
}





