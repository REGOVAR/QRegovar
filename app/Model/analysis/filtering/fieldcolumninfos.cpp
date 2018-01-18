#include "fieldcolumninfos.h"



FieldColumnInfos::FieldColumnInfos(QObject* parent) : QObject(parent)
{

}

FieldColumnInfos::FieldColumnInfos(Annotation* annotation, bool isDisplayed, QString sortFilter, QObject* parent ) : QObject(parent)
{
    mAnnotation = annotation;
    mIsDisplayed = isDisplayed;
    mIsDisplayedTemp = isDisplayed;
    mSortFilter = sortFilter;
    mWith = 150;
}
