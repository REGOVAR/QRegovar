#include "resultstreeitem.h"
#include "Model/regovar.h"
#include "Model/sample/sample.h"

// ResultsTreeItem ----------------------------------------------

ResultsTreeItem::ResultsTreeItem(FilteringAnalysis* parent) : QObject(parent)
{
    mFilteringAnalysis = parent;
}

ResultsTreeItem::ResultsTreeItem(const ResultsTreeItem &other) : QObject(other.parent())
{
    mFilteringAnalysis = other.mFilteringAnalysis;
    mValue = other.mValue;
    mUid= other.mUid;
}

ResultsTreeItem::~ResultsTreeItem()
{}



ResultsTreeItem::ResultsTreeItem(QString uid, QVariant value, FilteringAnalysis* parent) : QObject(parent)
{
    mFilteringAnalysis = parent;
    mValue = value;
    mUid= uid;
}







// ResultsTreeItem4SampleArray ----------------------------------------------
ResultsTreeItem4SampleArray::ResultsTreeItem4SampleArray(FilteringAnalysis* parent) : QObject(parent)
{
    mFilteringAnalysis = parent;
}

ResultsTreeItem4SampleArray::ResultsTreeItem4SampleArray(const ResultsTreeItem4SampleArray &other) : QObject(other.parent())
{
    mFilteringAnalysis = other.mFilteringAnalysis;
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
    foreach (Sample* sample, mFilteringAnalysis->samples())
    {
        QVariant v = mSamplesValues.value(sample->id());
        mDisplayedValues.append(v.toString());
    }
    emit valuesChanged();
}
