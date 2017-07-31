#ifndef ANNOTATIONSTREEMODEL_H
#define ANNOTATIONSTREEMODEL_H

#include "Model/treemodel.h"
#include "annotation.h"

class AnnotationsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingUpdated)

public:

    enum AnnotationsModelRoles
    {
        NameRole = Qt::UserRole + 1,
        VersionRole,
        DescriptionRole,
    };


    explicit AnnotationsTreeModel(int refId);
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();
    QVariant newAnnotationsTreeViewItem(QString id, const QVariant &value);
    void setupModelData(QJsonArray data, TreeItem *parent);


    // Accessors
    inline bool isLoading() { return mIsLoading; }
    Q_INVOKABLE Annotation* getAnnotation(QString uid) ;
    inline QHash<QString, Annotation*>* annotations() { return &mAnnotations;}

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingUpdated(); }
    inline void addAnnotation(QString uid, Annotation* annotation) {mAnnotations.insert(uid, annotation); }


Q_SIGNALS:
    void isLoadingUpdated();


private:
    bool mIsLoading;
    int mRefId;
    QString mRefName;

    QHash<QString, Annotation*> mAnnotations;
};

#endif // ANNOTATIONSTREEMODEL_H
