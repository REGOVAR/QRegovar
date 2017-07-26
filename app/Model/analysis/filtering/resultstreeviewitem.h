#ifndef RESULTSTREEVIEWITEM_H
#define RESULTSTREEVIEWITEM_H

#include "Model/treeitem.h"

class ResultsTreeViewItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:


    explicit ResultsTreeViewItem(QObject *parent = 0);
    explicit ResultsTreeViewItem(QString uid, QString text, QObject *parent = 0);
    ResultsTreeViewItem(const ResultsTreeViewItem &other);
    ~ResultsTreeViewItem();

    inline QString text() { return mText; }
    inline QString uid() { return mUid; }

    inline void setText(QString text) { mText = text; emit textChanged(); }
    inline void setUid(QString uid) { mUid = uid; emit uidChanged(); }

signals:
    void textChanged();
    void uidChanged();

private:
    QString mText;
    QString mUid;
};

#endif // RESULTSTREEVIEWITEM_H
