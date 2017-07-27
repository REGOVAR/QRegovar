#ifndef RESULTSTREEVIEWMODEL_H
#define RESULTSTREEVIEWMODEL_H

#include "Model/treemodel.h"
#include "annotationmodel.h"

class ResultsTreeViewModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingUpdated)

public:

    explicit ResultsTreeViewModel(int analysisId);
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();
    QVariant newResultsTreeViewItem(QString uid, const QVariant &value);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void loadAnalysisData();


    // Accessors
    inline bool isLoading() { return mIsLoading; }

    // Setters
    inline bool setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingUpdated(); }


Q_SIGNALS:
    void isLoadingUpdated();


private:
    bool mIsLoading;

    QStringList mDisplayedAnnotations;
    int mAnalysisId;

};

#endif // RESULTSTREEVIEWMODEL_H
