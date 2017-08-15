#include "fieldcolumninfos.h"



FieldColumnInfos::FieldColumnInfos(QObject *parent) : QObject(parent)
{

}

FieldColumnInfos::FieldColumnInfos(Annotation* annotation, bool isDisplayed, int displayOrder, QString sortFilter)
{
    mAnnotation = annotation;
    mIsDisplayed = isDisplayed;
    mSortFilter = sortFilter;
    mDisplayOrder = displayOrder;
    mWith = 150;
    if (annotation != nullptr)
    {
        mIsSampleColumn = (annotation->name() == "GT" || annotation->name() == "DP");
    }
}
