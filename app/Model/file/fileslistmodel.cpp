#include "fileslistmodel.h"
#include "Model/regovar.h"

FilesListModel::FilesListModel(QObject* parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
}



bool FilesListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mFileList.clear();
    for (const QJsonValue& eventJson: json)
    {
        QJsonObject fileData = eventJson.toObject();
        File* file = regovar->filesManager()->getOrCreateFile(fileData["id"].toInt());
        file->loadJson(fileData);
        if (!mFileList.contains(file))
        {
            mFileList.append(file);
        }
    }
    endResetModel();
    emit countChanged();
    return true;
}



bool FilesListModel::append(File* file)
{
    bool result = false;
    if (file!= nullptr && !mFileList.contains(file))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mFileList.append(file);
        endInsertRows();
        emit countChanged();
        emit fileAdded(file->id());
        result = true;
    }
    return result;
}

bool FilesListModel::remove(File* file)
{
    bool result = false;
    if (!mFileList.contains(file))
    {
        int pos = mFileList.indexOf(file);
        beginRemoveRows(QModelIndex(), pos, pos);
        mFileList.removeAt(pos);
        endRemoveRows();
        emit countChanged();
        emit fileRemoved(file->id());
        result = true;
    }
    return result;
}


bool FilesListModel::refresh()
{
    qDebug() << "TODO: FilesListModel::refresh()";
    return false;
}


bool FilesListModel::clear()
{
    beginResetModel();
    mFileList.clear();
    endResetModel();
    emit countChanged();
    return true;
}

File* FilesListModel::getAt(int position)
{
    if (position >= 0 && position < mFileList.count())
    {
        return mFileList[position];
    }
    return nullptr;
}


bool FilesListModel::contains(File* file)
{
    return mFileList.contains(file);
}


int FilesListModel::rowCount(const QModelIndex&) const
{
    return mFileList.count();
}



QVariant FilesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mFileList.count())
        return QVariant();

    const File* file= mFileList[index.row()];
    if (role == Name || role == Qt::DisplayRole)
        return file->filenameUI();
    else if (role == Id)
        return file->id();
    else if (role == Type)
        return file->type();
    else if (role == Comment)
        return file->comment();
    else if (role == Url)
        return file->url();
    else if (role == Md5Sum)
        return file->md5Sum();
    else if (role == UpdateDate)
        return regovar->formatDate(file->updateDate());
    else if (role == Size)
        return file->sizeUI();
    else if (role == Status)
        return file->statusUI();
    else if (role == Source)
        return file->sourceUI();
    else if (role == SearchField)
        return file->searchField();
    return QVariant();
}



QHash<int, QByteArray> FilesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Name] = "name";
    roles[Comment] = "comment";
    roles[Url] = "url";
    roles[Md5Sum] = "md5sum";
    roles[UpdateDate] = "updateDate";
    roles[Type] = "type";
    roles[Size] = "size";
    roles[Status] = "status";
    roles[Source] = "source";
    roles[SearchField] = "searchField";
    return roles;
}

