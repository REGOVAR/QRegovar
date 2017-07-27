#ifndef ANNOTATIONSTREEVIEWITEM_H
#define ANNOTATIONSTREEVIEWITEM_H

#include "Model/treeitem.h"

class AnnotationsTreeViewItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)

public:


    explicit AnnotationsTreeViewItem(QObject *parent = 0);
    explicit AnnotationsTreeViewItem(QString uid, QVariant value, QObject *parent = 0);
    AnnotationsTreeViewItem(const AnnotationsTreeViewItem &other);
    ~AnnotationsTreeViewItem();

    inline QVariant value() { return mValue; }
    inline QString uid() { return mUid; }

    inline void setValue(QVariant value) { mValue = value; emit valueChanged(); }
    inline void setUid(QString uid) { mUid = uid; emit uidChanged(); }

signals:
    void valueChanged();
    void uidChanged();

private:
    QVariant mValue;
    QString mUid;
};

#endif // ANNOTATIONSTREEVIEWITEM_H