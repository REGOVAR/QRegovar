#include "quickfilterblockinterface.h"


QuickFilterField::QuickFilterField(QString fuid, QString op, QVariant value, bool isActive, QObject* parent)
    : QObject(parent)
{
    mFuid = fuid;
    mOperator = op;
    mDefaultOperator = op;
    mValue = value;
    mDefaultValue = value;
    mIsActive = isActive;
    mDefaultIsActive = isActive;

}


QuickFilterField::QuickFilterField(const QuickFilterField& other) : QObject(other.parent())
{
    mFuid = other.mFuid;
    mOperator = other.mOperator;
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
