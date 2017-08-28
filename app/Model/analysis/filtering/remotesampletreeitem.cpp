#include "remotesampletreeitem.h"
#include "Model/regovar.h"
#include "Model/sample/sample.h"

// RemoteSampleTreeItem ----------------------------------------------

RemoteSampleTreeItem::RemoteSampleTreeItem(FilteringAnalysis* parent) : QObject(parent)
{
    mFilteringAnalysis = parent;
}


RemoteSampleTreeItem::RemoteSampleTreeItem(int sampleId, int subjectId, int fileId, QVariant value, FilteringAnalysis* parent) : QObject(parent)
{
    mFilteringAnalysis = parent;
    mValue = value;
    mSampleId = sampleId;
    mSubjectId = subjectId;
    mFileId = fileId;
}

