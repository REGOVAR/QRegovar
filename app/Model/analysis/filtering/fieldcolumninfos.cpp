#include "fieldcolumninfos.h"



FieldColumnInfos::FieldColumnInfos(QObject* parent) : QObject(parent)
{

}

FieldColumnInfos::FieldColumnInfos(Annotation* annotation, bool isDisplayed, int displayOrder, QString sortFilter, QObject* parent ) : QObject(parent)
{
    mAnnotation = annotation;
    mIsDisplayed = isDisplayed;
    mSortFilter = sortFilter;
    mDisplayOrder = displayOrder;
    mWith = 150;
    mRole = NormalAnnotation;
}
