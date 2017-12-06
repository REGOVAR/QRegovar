#ifndef PANELSTREEITEM_H
#define PANELSTREEITEM_H

#include "Model/framework/treeitem.h"

class PanelsTreeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString version READ version WRITE setVersion NOTIFY versionChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    // Constructors
    explicit PanelsTreeItem(QObject* parent=nullptr);
    explicit PanelsTreeItem(int id, QString version, QString text, QObject* parent=nullptr);

    // Getters
    inline int id() { return mId; }
    inline QString version() { return mVersion; }
    inline QString text() { return mText; }

    // Setters
    inline void setId(int id) { mId = id; emit idChanged(); }
    inline void setVersion(QString version) { mVersion = version; emit versionChanged(); }
    inline void setText(QString text) { mText = text; emit textChanged(); }

Q_SIGNALS:
    void idChanged();
    void versionChanged();
    void textChanged();

private:
    int mId = -1;
    QString mVersion;
    QString mText;
};

#endif // PANELSTREEITEM_H
