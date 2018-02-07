#ifndef ANNOTATIONSTREEMODEL_H
#define ANNOTATIONSTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "annotation.h"
#include "fieldcolumninfos.h"
#include "filteringanalysis.h"
#include "Model/sortfilterproxymodel/annotationsproxymodel.h"

class FilteringAnalysis;

class AnnotationsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(AnnotationsProxyModel* proxy READ proxy NOTIFY proxyChanged)

public:

    enum Roles
    {
        Id = Qt::UserRole + 1,
        Checked,
        Name,
        Version,
        Description,
        SearchField
    };

    // Constructor
    explicit AnnotationsTreeModel(FilteringAnalysis* analysis=nullptr);

    // Getters
    inline bool isLoading() const { return mIsLoading; }
    inline AnnotationsProxyModel* proxy() const { return mProxy; }

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }

    // Methods
    Q_INVOKABLE FieldColumnInfos* getAnnotation(QString uid) ;
    Q_INVOKABLE FieldColumnInfos* getAnnotation(const QModelIndex &index);

    // QAbstractItemModel methods
    QHash<int, QByteArray> roleNames() const override;
    //inline QHash<QString, Annotation*>* annotations() { return &mAnnotations;}
    //inline void addAnnotation(QString uid, Annotation* annotation) {mAnnotations.insert(uid, annotation); }
    bool fromJson(QJsonObject data, QStringList dbUids);
    void addEntry(QString dbName, QString dbVersion, QString dbDescription, bool isDbSelected, FieldColumnInfos* data);
    void setupModelData(QJsonArray data, TreeItem *parent, QStringList dbUids);

Q_SIGNALS:
    void isLoadingChanged();
    void proxyChanged();

private:
    bool mIsLoading = false;
    int mRefId = -1;
    QString mRefName;
    FilteringAnalysis* mAnalysis;
    AnnotationsProxyModel* mProxy;
};

#endif // ANNOTATIONSTREEMODEL_H
