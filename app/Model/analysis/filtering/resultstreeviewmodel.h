#ifndef RESULTSTREEVIEWMODEL_H
#define RESULTSTREEVIEWMODEL_H

#include "Model/treemodel.h"
#include "annotationmodel.h"

class ResultsTreeViewModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingUpdated)

public:

    explicit ResultsTreeViewModel();
    QHash<int, QByteArray> roleNames() const override;

    void refresh();
    QVariant newResultsTreeViewItem(QString uid, const QString &text);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void loadColumnsRolesFromAnnotations();


    // Accessors
    inline bool isLoading() { return mIsLoading; }

    // Setters
    inline bool setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingUpdated(); }


Q_SIGNALS:
    void isLoadingUpdated();


private:
    bool mIsLoading;

    QHash<QString, AnnotationModel*> mAnnotations;
    QList<QString> mDisplayedAnnotations;
};

#endif // RESULTSTREEVIEWMODEL_H
