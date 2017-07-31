#ifndef RESULTSTREEITEM_H
#define RESULTSTREEITEM_H

#include "Model/treeitem.h"

class ResultsTreeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)

public:


    explicit ResultsTreeItem(QObject *parent = 0);
    explicit ResultsTreeItem(QString uid, QVariant text, QObject *parent = 0);
    ResultsTreeItem(const ResultsTreeItem &other);
    ~ResultsTreeItem();

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

#endif // RESULTSTREEITEM_H
