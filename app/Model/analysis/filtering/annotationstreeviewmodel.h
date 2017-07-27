#ifndef ANNOTATIONSTREEVIEWMODEL_H
#define ANNOTATIONSTREEVIEWMODEL_H

#include "Model/treemodel.h"
#include "annotationmodel.h"

class AnnotationsTreeViewModel : public TreeModel
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


    explicit AnnotationsTreeViewModel(int refId);
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();
    QVariant newAnnotationsTreeViewItem(QString id, const QVariant &value);
    void setupModelData(QJsonArray data, TreeItem *parent);


    // Accessors
    inline bool isLoading() { return mIsLoading; }
    Q_INVOKABLE AnnotationModel* getAnnotation(QString uid) ;

    // Setters
    inline bool setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingUpdated(); }
    inline void addAnnotation(QString uid, AnnotationModel* annotation) {mAnnotations.insert(uid, annotation); }


Q_SIGNALS:
    void isLoadingUpdated();


private:
    bool mIsLoading;
    int mRefId;
    QString mRefName;

    QHash<QString, AnnotationModel*> mAnnotations;
};

#endif // ANNOTATIONSTREEVIEWMODEL_H
