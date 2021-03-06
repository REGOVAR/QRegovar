#ifndef DYNAMICFORMMODEL_H
#define DYNAMICFORMMODEL_H

#include <QtCore>
#include "dynamicformfieldmodel.h"
#include "Model/pipeline/pipeline.h"
#include "Model/framework/genericproxymodel.h"
#include "Model/file/fileslistmodel.h"


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
    Q_PROPERTY(FilesListModel* inputsFiles READ inputsFiles WRITE setInputsFiles NOTIFY neverChanged)
    Q_PROPERTY(bool loaded READ loaded NOTIFY loadedChanged)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)
    Q_PROPERTY(double labelWidth READ labelWidth WRITE setLabelWidth NOTIFY labelWidthChanged)

public:
    // Constructor
     DynamicFormModel(QObject* parent=nullptr);

    // Getters
    inline FilesListModel* inputsFiles() const { return mInputsFiles; }
    inline bool loaded() const { return mLoaded; }
    inline GenericProxyModel* proxy() const { return mProxy; }
    inline double labelWidth() const { return mLabelWidth; }

    // Setters
    inline void setInputsFiles(FilesListModel* lst) { mInputsFiles = lst; }
    inline void setLabelWidth(double width) { mLabelWidth = width; emit labelWidthChanged(); }

    // Methods
    Q_INVOKABLE void load(QUrl jsonUrl);
    Q_INVOKABLE void load(QJsonObject json);
    Q_INVOKABLE void refresh();
    Q_INVOKABLE void reset();
    Q_INVOKABLE bool validate();
    Q_INVOKABLE QJsonObject getResult();
    Q_INVOKABLE DynamicFormFieldModel* getAt(int position);
    //! Print JSON config as qstring
    Q_INVOKABLE QString printConfig();

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
    //! The optional ref to the list of inputs files associated to this form
    FilesListModel* mInputsFiles = nullptr;
    //! List of form field
    QList<DynamicFormFieldModel*> mFieldList;
    //! The QSortFilterProxyModel to use by table view to browse fields
    GenericProxyModel* mProxy = nullptr;
    //! Width of the label to use for all field of the form (to have beautifull design)
    double mLabelWidth = 50;
};

#endif // DYNAMICFORMMODEL_H
