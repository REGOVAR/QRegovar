#ifndef FILESLISTMODEL_H
#define FILESLISTMODEL_H

#include <QtCore>
#include "file.h"
#include "Model/framework/genericproxymodel.h"

class FilesListModel : public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Name,
        Comment,
        Url,
        Md5Sum,
        UpdateDate,
        Type,
        Size,
        Status,
        Source,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructor
    FilesListModel(QObject* parent = nullptr);

    // Getters
    inline GenericProxyModel* proxy() const { return mProxy; }

    // Methods
    Q_INVOKABLE bool loadJson(QJsonArray json);
    Q_INVOKABLE bool add(File* file);
    Q_INVOKABLE bool remove(File* file);
    Q_INVOKABLE bool refresh();
    Q_INVOKABLE bool clear();
    Q_INVOKABLE File* getAt(int position);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

Q_SIGNALS:
    void neverChanged();
    void countChanged();

private:
    //! List of files
    QList<File*> mFileList;
    //! The QSortFilterProxyModel to use by table view to browse files of the list
    GenericProxyModel* mProxy = nullptr;
    //! Last time that the list refresh have been called
    QDateTime mLastUpdate;


};

#endif // FILESLISTMODEL_H
