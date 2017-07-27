#ifndef FILESTREEVIEWITEM_H
#define FILESTREEVIEWITEM_H

#include "Model/treeitem.h"

class FilesTreeViewItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:

    // Constructors
    explicit FilesTreeViewItem(QObject *parent = 0);
    explicit FilesTreeViewItem(int id, QString text, QObject *parent = 0);
    FilesTreeViewItem(const FilesTreeViewItem &other);
    ~FilesTreeViewItem();

    // Accessors
    inline QString text() { return mText; }
    inline int id() { return mId; }
    inline int size() { return mSize; }
    inline int uploadOffset() { return mOffset; }

    // Setters
    inline void setText(QString text) { mText = text; emit textChanged(); }
    inline void setId(int id) { mId = id; emit idChanged(); }
    inline void setSize(qint64 size) { mSize = size; }
    inline void setUploadOffset(qint64 offset) { mOffset = offset; }


signals:
    void textChanged();
    void idChanged();

private:
    QString mText;
    int mId;
    qint64 mSize;
    qint64 mOffset;
};

#endif // FILESTREEVIEWITEM_H