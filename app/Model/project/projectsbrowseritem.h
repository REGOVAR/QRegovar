#ifndef PROJECTSBROWSERITEM_H
#define PROJECTSBROWSERITEM_H

#include "Model/treeitem.h"

class ProjectsBrowserItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(int indentation READ indentation WRITE setIndentation NOTIFY indentationChanged)

public:
    explicit ProjectsBrowserItem(QObject *parent = 0);
    ProjectsBrowserItem(const ProjectsBrowserItem &other);
    ~ProjectsBrowserItem();

    QString text();
    void setText(QString text);

    int indentation();
    void setIndentation(int indentation);

signals:
    void textChanged();
    void indentationChanged();

private:
    QString myText;
    int myIndentation;
};

Q_DECLARE_METATYPE(ProjectsBrowserItem)

#endif // PROJECTSBROWSERITEM_H
