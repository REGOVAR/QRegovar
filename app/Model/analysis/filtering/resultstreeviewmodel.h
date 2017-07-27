#ifndef RESULTSTREEVIEWMODEL_H
#define RESULTSTREEVIEWMODEL_H

#include "Model/treemodel.h"
#include "annotationmodel.h"

class ResultsTreeViewModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingUpdated)
    Q_PROPERTY(QString filter READ filter WRITE setFilter NOTIFY filterUpdated)
    Q_PROPERTY(QStringList fields READ fields NOTIFY fieldsUpdated)

public:

    explicit ResultsTreeViewModel(int analysisId);
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();
    QVariant newResultsTreeViewItem(QString uid, const QVariant &value);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void loadAnalysisData();


    // Accessors
    inline bool isLoading() { return mIsLoading; }
    inline QString filter() { return mFilter; }
    inline QStringList fields() { return mFields; }

    // Setters
    Q_INVOKABLE inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingUpdated(); }
    Q_INVOKABLE inline void setFilter(QString filter) { mFilter = filter; emit filterUpdated(); }


Q_SIGNALS:
    void isLoadingUpdated();
    void filterUpdated();
    void fieldsUpdated();

private:
    bool mIsLoading;

    QStringList mFields;
    QString mFilter;
    int mAnalysisId;


};

#endif // RESULTSTREEVIEWMODEL_H
