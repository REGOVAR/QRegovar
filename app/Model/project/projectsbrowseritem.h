#ifndef PROJECTSBROWSERITEM_H
#define PROJECTSBROWSERITEM_H

#include "Model/treeitem.h"

class ProjectsBrowserItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:


    explicit ProjectsBrowserItem(QObject *parent = 0);
    explicit ProjectsBrowserItem(int id, QString text, QObject *parent = 0);
    ProjectsBrowserItem(const ProjectsBrowserItem &other);
    ~ProjectsBrowserItem();

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

#endif // PROJECTSBROWSERITEM_H
