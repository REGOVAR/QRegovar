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





QuickFilterField::QuickFilterField(const QuickFilterField& other) : QObject(other.parent())
{
    mIsDisplayed = other.mIsDisplayed;
    mFuid = other.mFuid;
    mLabel = other.mLabel;
    mOperator = other.mOperator;
    mOperatorsValues = other.mOperatorsValues;
    mDefaultOperator = other.mDefaultOperator;
    mValue = other.mValue;
    mDefaultValue = other.mDefaultValue;
    mIsActive = other.mIsActive;
    mDefaultIsActive = other.mDefaultIsActive;
}


QuickFilterField::~QuickFilterField()
{
}


void QuickFilterField::clear()
{
    mOperator = mDefaultOperator;
    mValue = mDefaultValue;
    mIsActive = mDefaultIsActive;
    emit opChanged();
    emit valueChanged();
    emit isActiveChanged();
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
    result.append(mOpMapping[mOperator]);
    result.append(opLeft);
    result.append(opRight);
    return result;
}



QuickFilterBlockInterface::QuickFilterBlockInterface(QObject *parent) : QObject(parent)
{
}





