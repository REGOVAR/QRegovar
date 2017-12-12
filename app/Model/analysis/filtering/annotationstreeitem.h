#ifndef ANNOTATIONSTREEITEM_H
#define ANNOTATIONSTREEITEM_H

#include "Model/framework/treeitem.h"

class AnnotationsTreeItem : public TreeItem
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)
    Q_PROPERTY(bool checked READ checked WRITE setChecked NOTIFY checkedChanged)

public:
    // Constructors
    explicit AnnotationsTreeItem(TreeItem* parent=nullptr);
    explicit AnnotationsTreeItem(const QString uid, const bool checked, const QHash<int, QVariant>& data, TreeItem* parent=nullptr);

    // Getters
    inline QString uid() { return mUid; }
    inline bool checked() { return mIsChecked;}

    // Setters
    inline void setUid(QString uid) { mUid = uid; emit uidChanged(); }
    void setChecked(bool checked) ;

Q_SIGNALS:
    void uidChanged();
    void checkedChanged();

private:
    QString mUid;
    bool mIsChecked = false;
};

#endif // ANNOTATIONSTREEITEM_H
