#include "projectsbrowseritem.h"


ProjectsBrowserItem::ProjectsBrowserItem(QObject *parent) : QObject(parent), myIndentation(0)
{
}

ProjectsBrowserItem::ProjectsBrowserItem(const ProjectsBrowserItem &other)
{
    myText = other.myText;
    myIndentation = other.myIndentation;
}

ProjectsBrowserItem::~ProjectsBrowserItem()
{
}

QString ProjectsBrowserItem::text()
{
    return myText;
}

void ProjectsBrowserItem::setText(QString text)
{
    myText = text;
    emit textChanged();
}

int ProjectsBrowserItem::indentation()
{
    return myIndentation;
}

void ProjectsBrowserItem::setIndentation(int indentation)
{
    myIndentation = indentation;
    emit indentationChanged();
}
