#ifndef FILESTREEITEM_H
#define FILESTREEITEM_H

#include "Model/framework/treeitem.h"

class FilesTreeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:

    // Constructors
    explicit FilesTreeItem(QObject *parent = 0);
    explicit FilesTreeItem(int id, QString text, QObject *parent = 0);
    FilesTreeItem(const FilesTreeItem &other);
    ~FilesTreeItem();

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
    int mId = -1;
    qint64 mSize = 0;
    qint64 mOffset = 0;
};

#endif // FILESTREEITEM_H
