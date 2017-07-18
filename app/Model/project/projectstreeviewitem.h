#ifndef PROJECTSTREEVIEWITEM_H
#define PROJECTSTREEVIEWITEM_H

#include "Model/treeitem.h"

class ProjectsTreeViewItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:


    explicit ProjectsTreeViewItem(QObject *parent = 0);
    explicit ProjectsTreeViewItem(int id, QString text, QObject *parent = 0);
    ProjectsTreeViewItem(const ProjectsTreeViewItem &other);
    ~ProjectsTreeViewItem();

    inline QString text() { return mText; }
    inline int id() { return mId; }

    inline void setText(QString text) { mText = text; emit textChanged(); }
    inline void setId(int id) { mId = id; emit idChanged(); }

signals:
    void textChanged();
    void idChanged();

private:
    QString mText;
    int mId;
};

#endif // PROJECTSTREEVIEWITEM_H
