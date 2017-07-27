#ifndef ANNOTATIONSTREEVIEWITEM_H
#define ANNOTATIONSTREEVIEWITEM_H

#include "Model/treeitem.h"

class AnnotationsTreeViewItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)

public:


    explicit AnnotationsTreeViewItem(QObject *parent = 0);
    explicit AnnotationsTreeViewItem(QString id, QVariant value, QObject *parent = 0);
    AnnotationsTreeViewItem(const AnnotationsTreeViewItem &other);
    ~AnnotationsTreeViewItem();

    inline QVariant value() { return mValue; }
    inline QString id() { return mId; }

    inline void setValue(QVariant value) { mValue = value; emit valueChanged(); }
    inline void setId(QString id) { mId = id; emit idChanged(); }

signals:
    void valueChanged();
    void idChanged();

private:
    QVariant mValue;
    QString mId;
};

#endif // ANNOTATIONSTREEVIEWITEM_H
