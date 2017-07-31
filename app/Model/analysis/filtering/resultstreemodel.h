#ifndef RESULTSTREEMODEL_H
#define RESULTSTREEMODEL_H

#include "Model/treemodel.h"
#include "annotation.h"

class ResultsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingUpdated)
    Q_PROPERTY(QString filter READ filter WRITE setFilter NOTIFY filterUpdated)
    Q_PROPERTY(QStringList fields READ fields NOTIFY fieldsUpdated)

public:

    explicit ResultsTreeModel(int analysisId);
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();
    Q_INVOKABLE inline int fieldsCount() { return mFields.count(); }
    QVariant newResultsTreeViewItem(QString uid, const QVariant &value);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void loadAnalysisData();


    // Getters
    inline bool isLoading() { return mIsLoading; }
    inline QString filter() { return mFilter; }
    inline QStringList fields() { return mFields; }

    // Setters
    Q_INVOKABLE inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingUpdated(); }
    Q_INVOKABLE inline void setFilter(QString filter) { mFilter = filter; emit filterUpdated(); }
    Q_INVOKABLE int setField(QString uid, bool isDisplayed, int order=-1);


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

#endif // RESULTSTREEMODEL_H
