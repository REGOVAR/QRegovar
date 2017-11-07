#ifndef ANNOTATIONSTREEITEM_H
#define ANNOTATIONSTREEITEM_H

#include "Model/framework/treeitem.h"

class AnnotationsTreeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(bool checked READ checked WRITE setChecked NOTIFY checkedChanged)

public:


    explicit AnnotationsTreeItem(QObject *parent = 0);
    explicit AnnotationsTreeItem(QString uid, QVariant value, QObject *parent = 0);
    AnnotationsTreeItem(const AnnotationsTreeItem &other);
    ~AnnotationsTreeItem();

    inline QVariant value() { return mValue; }
    inline QString uid() { return mUid; }
    inline bool checked() { return mIsChecked;}

    inline void setValue(QVariant value) { mValue = value; emit valueChanged(); }
    inline void setUid(QString uid) { mUid = uid; emit uidChanged(); }
    void setChecked(bool checked) ;

signals:
    void valueChanged();
    void uidChanged();
    void checkedChanged();

private:
    QVariant mValue;
    QString mUid;
    bool mIsChecked;
};

#endif // ANNOTATIONSTREEITEM_H
