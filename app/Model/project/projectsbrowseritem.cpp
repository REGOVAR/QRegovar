#include "projectsbrowseritem.h"


ProjectsBrowserItem::ProjectsBrowserItem(QObject *parent) : QObject(parent)
{}

ProjectsBrowserItem::ProjectsBrowserItem(const ProjectsBrowserItem &other)
{
    mText = other.mText;
    mId= other.mId;
}

ProjectsBrowserItem::~ProjectsBrowserItem()
{}



ProjectsBrowserItem::ProjectsBrowserItem(int id, QString text, QObject *parent) : QObject(parent)
{
    mText = text;
    mId= id;
}
