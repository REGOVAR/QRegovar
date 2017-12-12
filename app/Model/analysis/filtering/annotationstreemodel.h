#ifndef ANNOTATIONSTREEMODEL_H
#define ANNOTATIONSTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "annotation.h"
#include "fieldcolumninfos.h"

class AnnotationsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)

public:

    enum AnnotationsModelRoles
    {
        IdRole = Qt::UserRole + 1,
        CheckedRole,
        NameRole,
        VersionRole,
        DescriptionRole,
    };


    explicit AnnotationsTreeModel(QObject* parent=nullptr);
    QHash<int, QByteArray> roleNames() const override;

    bool fromJson(QJsonObject data, QStringList dbUids);
    void addEntry(QString dbName, QString dbVersion, QString dbDescription, bool isDbSelected, FieldColumnInfos* data);
    void setupModelData(QJsonArray data, TreeItem *parent, QStringList dbUids);


    // Accessors
    inline bool isLoading() { return mIsLoading; }
    Q_INVOKABLE Annotation* getAnnotation(const QModelIndex &index);
    Q_INVOKABLE Annotation* getAnnotation(QString uid) ;
    inline QHash<QString, Annotation*>* annotations() { return &mAnnotations;}

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }
    inline void addAnnotation(QString uid, Annotation* annotation) {mAnnotations.insert(uid, annotation); }


Q_SIGNALS:
    void isLoadingChanged();


private:
    bool mIsLoading = false;
    int mRefId = -1;
    QString mRefName;

    QHash<QString, Annotation*> mAnnotations;
};

#endif // ANNOTATIONSTREEMODEL_H
