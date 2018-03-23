#ifndef FILESTREEITEM_H
#define FILESTREEITEM_H

#include "Model/framework/treeitem.h"

class FilesTreeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY dataChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY dataChanged)

public:

    // Constructors
    explicit FilesTreeItem(QObject* parent=nullptr);
    explicit FilesTreeItem(int id, QVariant value, QObject* parent=nullptr);

    // Accessors
    inline QVariant value() { return mValue; }
    inline int id() { return mId; }

    // Setters
    inline void setValue(QVariant value) { mValue = value; emit dataChanged(); }
    inline void setId(int id) { mId = id; emit dataChanged(); }


Q_SIGNALS:
    void dataChanged();

private:
    QVariant mValue;
    int mId = -1;
};

#endif // FILESTREEITEM_H
