#ifndef RESULTSTREEVIEWITEM_H
#define RESULTSTREEVIEWITEM_H

#include "Model/treeitem.h"

class ResultsTreeViewItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)

public:


    explicit ResultsTreeViewItem(QObject *parent = 0);
    explicit ResultsTreeViewItem(QString uid, QVariant text, QObject *parent = 0);
    ResultsTreeViewItem(const ResultsTreeViewItem &other);
    ~ResultsTreeViewItem();

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

#endif // RESULTSTREEVIEWITEM_H
