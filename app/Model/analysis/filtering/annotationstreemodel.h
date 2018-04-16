#ifndef ANNOTATIONSTREEMODEL_H
#define ANNOTATIONSTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "annotation.h"
#include "fieldcolumninfos.h"
#include "filteringanalysis.h"
#include "Model/framework/genericproxymodel.h"

class FilteringAnalysis;

class AnnotationsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:

    enum Roles
    {
        Id = Qt::UserRole + 1,
        DbId,
        Order,
        Selected,
        Name,
        Version,
        Description,
        SearchField
    };

    // Constructor
    explicit AnnotationsTreeModel(FilteringAnalysis* analysis=nullptr);

    // Getters
    inline bool isLoading() const { return mIsLoading; }
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }

    // Methods
    Q_INVOKABLE FieldColumnInfos* getAnnotation(QString uid) ;
    Q_INVOKABLE FieldColumnInfos* getAnnotation(const QModelIndex &index);

    // QAbstractItemModel methods
    QHash<int, QByteArray> roleNames() const override;
    //inline QHash<QString, Annotation*>* annotations() { return &mAnnotations;}
    //inline void addAnnotation(QString uid, Annotation* annotation) {mAnnotations.insert(uid, annotation); }
    bool loadJson(QJsonObject data, QStringList dbUids);
    void addEntry(QString dbName, QString dbVersion, QString dbDescription, bool isDbSelected, FieldColumnInfos* data);
    void setupModelData(QJsonArray data, TreeItem *parent, QStringList dbUids);

Q_SIGNALS:
    void neverChanged();
    // Property changed event
    void isLoadingChanged();

private:
    //! Flag to know if the model is loading or not
    bool mIsLoading = false;
    //! The common reference id to the annotations
    int mRefId = -1;
    //! The common reference name to the annotations
    QString mRefName;
    //! A ref to the root analysis
    FilteringAnalysis* mAnalysis = nullptr;
    //! The QSortFilterProxyModel to use by tree view to browse project/analyse of the manager
    GenericProxyModel* mProxy = nullptr;
};

#endif // ANNOTATIONSTREEMODEL_H
