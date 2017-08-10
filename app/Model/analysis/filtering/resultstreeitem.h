#ifndef RESULTSTREEITEM_H
#define RESULTSTREEITEM_H

#include "Model/treeitem.h"
#include "Model/analysis/filtering/filteringanalysis.h"

//! Generic TreeItem
class ResultsTreeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)

public:


    explicit ResultsTreeItem(FilteringAnalysis* parent=nullptr);
    explicit ResultsTreeItem(QString uid, QVariant text, FilteringAnalysis* parent=nullptr);
    ResultsTreeItem(const ResultsTreeItem &other);
    ~ResultsTreeItem();

    inline QVariant value() { return mValue; }
    inline QString uid() { return mUid; }

    inline void setValue(QVariant value) { mValue = value; emit valueChanged(); }
    inline void setUid(QString uid) { mUid = uid; emit uidChanged(); }

signals:
    void valueChanged();
    void uidChanged();

private:
    FilteringAnalysis* mFilteringAnalysis;
    QVariant mValue;
    QString mUid;
};


// TODO : ResultsTreeItem4 { sequence, list, range }


//! TreeItem for sample's dependant column (GT, DP, ic_composite)
class ResultsTreeItem4SampleArray : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid NOTIFY uidChanged)
    Q_PROPERTY(QStringList values READ values NOTIFY valuesChanged)
    Q_PROPERTY(QString type READ type)

public:
    explicit ResultsTreeItem4SampleArray(FilteringAnalysis* parent = 0);
    ResultsTreeItem4SampleArray(const ResultsTreeItem4SampleArray &other);
    ~ResultsTreeItem4SampleArray();

    // Getters
    inline QString uid() { return mUid; }
    inline QString type() { return mValueType; }
    inline QStringList values() { return mDisplayedValues; }
    inline QHash<int, QVariant>* samplesValues() { return &mSamplesValues; }

    // Setters
    inline void setUid(QString uid) { mUid = uid; }
    inline void setType(QString type) { mValueType = type; }

    // Methods
    void refreshDisplayedValues();

signals:
    void valuesChanged();
    void uidChanged();

private:
    FilteringAnalysis* mFilteringAnalysis;
    QHash<int, QVariant> mSamplesValues;
    QStringList mDisplayedValues;
    QString mValueType;
    QString mUid;
};


#endif // RESULTSTREEITEM_H
