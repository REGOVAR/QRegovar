#ifndef REMOTESAMPLETREEITEM_H
#define REMOTESAMPLETREEITEM_H

#include "Model/treeitem.h"
#include "Model/analysis/filtering/filteringanalysis.h"


//! Generic TreeItem
class RemoteSampleTreeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int sampleId READ sampleId WRITE setSampleId NOTIFY sampleIdChanged)
    Q_PROPERTY(int subjectId READ subjectId WRITE setSubjectId NOTIFY subjectIdChanged)
    Q_PROPERTY(int fileId READ fileId WRITE setFileId NOTIFY fileIdChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)

public:
    explicit RemoteSampleTreeItem(FilteringAnalysis* parent=nullptr);
    explicit RemoteSampleTreeItem(int sampleId, int subjectId, int fileId, QVariant text, FilteringAnalysis* parent=nullptr);


    inline QVariant value() { return mValue; }
    inline int sampleId() { return mSampleId; }
    inline int subjectId() { return mSubjectId; }
    inline int fileId() { return mFileId; }

    inline void setValue(QVariant value) { mValue = value; emit valueChanged(); }
    inline void setSampleId(int sampleId) { mSampleId = sampleId; emit sampleIdChanged(); }
    inline void setSubjectId(int subjectId) { mSubjectId = subjectId; emit subjectIdChanged(); }
    inline void setFileId(int fileId) { mFileId = fileId; emit fileIdChanged(); }

signals:
    void valueChanged();
    void sampleIdChanged();
    void subjectIdChanged();
    void fileIdChanged();

private:
    FilteringAnalysis* mFilteringAnalysis;
    QVariant mValue;
    int mSampleId;
    int mSubjectId;
    int mFileId;
};



#endif // REMOTESAMPLETREEITEM_H
