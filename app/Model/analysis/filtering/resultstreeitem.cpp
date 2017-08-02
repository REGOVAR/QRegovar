#include "resultstreeitem.h"
#include "Model/regovar.h"
#include "Model/sample/sample.h"

// ResultsTreeItem ----------------------------------------------

ResultsTreeItem::ResultsTreeItem(QObject *parent) : QObject(parent)
{}

ResultsTreeItem::ResultsTreeItem(const ResultsTreeItem &other) : QObject(other.parent())
{
    mValue = other.mValue;
    mUid= other.mUid;
}

ResultsTreeItem::~ResultsTreeItem()
{}



ResultsTreeItem::ResultsTreeItem(QString uid, QVariant value, QObject *parent) : QObject(parent)
{
    mValue = value;
    mUid= uid;
}







// ResultsTreeItem4SampleArray ----------------------------------------------
ResultsTreeItem4SampleArray::ResultsTreeItem4SampleArray(QObject *parent) : QObject(parent)
{
}

ResultsTreeItem4SampleArray::ResultsTreeItem4SampleArray(const ResultsTreeItem4SampleArray &other) : QObject(other.parent())
{
    mUid= other.mUid;
    mValueType = other.mValueType;
    mSamplesValues = other.mSamplesValues;
    mDisplayedValues = other.mDisplayedValues;
}

ResultsTreeItem4SampleArray::~ResultsTreeItem4SampleArray()
{
}





//! Compute list of values used by QML according to model data
void ResultsTreeItem4SampleArray::refreshDisplayedValues()
{
    mDisplayedValues.clear();
    foreach (Sample* sample, regovar->currentFilteringAnalysis()->samples())
    {
        QVariant v = mSamplesValues.value(sample->id());
        mDisplayedValues.append(v.toString());
    }
    emit valuesChanged();
}
