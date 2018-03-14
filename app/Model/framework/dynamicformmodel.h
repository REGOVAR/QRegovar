#ifndef DYNAMICFORMMODEL_H
#define DYNAMICFORMMODEL_H

#include <QtCore>
#include "dynamicformfieldmodel.h"
#include "Model/pipeline/pipeline.h"
#include "Model/framework/genericproxymodel.h"

class Pipeline;
class DynamicFormFieldModel;

class DynamicFormModel : public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Order,
        Title,
        Description,
        Type,
        EnumValues,
        Required,
        Value,
        DefaultValue,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(bool loaded READ loaded NOTIFY loadedChanged)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)
    Q_PROPERTY(double labelWidth READ labelWidth WRITE setLabelWidth NOTIFY labelWidthChanged)

public:
    explicit DynamicFormModel(Pipeline* parent=nullptr);

    // Getters
    inline bool loaded() const { return mLoaded; }
    inline GenericProxyModel* proxy() const { return mProxy; }
    inline double labelWidth() const { return mLabelWidth; }

    // Setters
    inline void setLabelWidth(double width) { mLabelWidth = width; emit labelWidthChanged(); }

    // Methods
    Q_INVOKABLE void load(QUrl jsonUrl);
    Q_INVOKABLE void load(QJsonObject json);
    Q_INVOKABLE void reset();
    Q_INVOKABLE bool validate();
    Q_INVOKABLE QJsonObject getResult();
    Q_INVOKABLE DynamicFormFieldModel* getAt(int position);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

Q_SIGNALS:
    void neverChanged();
    void countChanged();
    void loadedChanged();
    void labelWidthChanged();

private:
    bool mLoaded = false;
    Pipeline* mPipeline = nullptr;
    //! List of form field
    QList<DynamicFormFieldModel*> mFieldList;
    //! The QSortFilterProxyModel to use by table view to browse fields
    GenericProxyModel* mProxy = nullptr;
    //! Width of the label to use for all field of the form (to have beautifull design)
    double mLabelWidth = 50;
};

#endif // DYNAMICFORMMODEL_H
