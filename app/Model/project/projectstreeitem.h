#ifndef PROJECTSTREEITEM_H
#define PROJECTSTREEITEM_H

#include "Model/framework/treeitem.h"

class ProjectsTreeItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(bool isAnalysis READ isAnalysis WRITE setIsAnalysis NOTIFY isAnalysisChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    // Constructors
    explicit ProjectsTreeItem(QObject* parent=nullptr);
    explicit ProjectsTreeItem(int id, QString text, QObject* parent=nullptr);

    // Getters
    inline QString text() { return mText; }
    inline int id() { return mId; }
    inline bool isAnalysis() { return mIsAnalysis; }

    // Setters
    inline void setText(QString text) { mText = text; emit textChanged(); }
    inline void setId(int id) { mId = id; emit idChanged(); }
    inline void setIsAnalysis(bool flag) { mIsAnalysis = flag; emit isAnalysisChanged(); }

Q_SIGNALS:
    void textChanged();
    void idChanged();
    void isAnalysisChanged();

private:
    QString mText;
    int mId = -1;
    bool mIsAnalysis = false;
};

#endif // PROJECTSTREEITEM_H
