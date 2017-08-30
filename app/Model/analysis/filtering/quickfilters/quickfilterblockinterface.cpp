#include "quickfilterblockinterface.h"


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

QuickFilterBlockInterface::QuickFilterBlockInterface(QObject *parent) : QObject(parent)
{
}
