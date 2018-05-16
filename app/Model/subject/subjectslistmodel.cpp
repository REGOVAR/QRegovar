#include "subjectslistmodel.h"
#include "subject.h"
#include "Model/regovar.h"


SubjectsListModel::SubjectsListModel(QObject *parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Identifier);
}


void SubjectsListModel::clear()
{
    beginResetModel();
    mSubjects.clear();
    endResetModel();
    emit countChanged();
}


bool SubjectsListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mSubjects.clear();
    for(const QJsonValue& val: json)
    {
        QJsonObject data = val.toObject();
        Subject* subject = regovar->subjectsManager()->getOrCreateSubject(data["id"].toInt());
        subject->loadJson(data, false);
        mSubjects.append(subject);
    }
    endResetModel();
    emit countChanged();
    return true;
}


bool SubjectsListModel::append(Subject* subject)
{
    if (subject!= nullptr && !mSubjects.contains(subject))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mSubjects.append(subject);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool SubjectsListModel::remove(Subject* subject)
{
    if (mSubjects.contains(subject))
    {
        int pos = mSubjects.indexOf(subject);
        beginRemoveRows(QModelIndex(), pos, pos);
        mSubjects.removeAll(subject);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}


Subject* SubjectsListModel::getAt(int idx)
{
    if (idx >=0 && idx<mSubjects.count())
    {
        return mSubjects[idx];
    }
    return nullptr;
}


int SubjectsListModel::rowCount(const QModelIndex&) const
{
    return mSubjects.count();
}


QVariant SubjectsListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mSubjects.count())
        return QVariant();

    Subject* subject = mSubjects[index.row()];
    if (role == Identifier || role == Qt::DisplayRole)
        return subject->identifier();
    else if (role == Id)
        return subject->id();
    else if (role == Firstname)
        return subject->firstname();
    else if (role == Lastname)
        return subject->lastname();
    else if (role == Comment)
        return subject->comment();
    else if (role == Sex)
        return subject->sex() == Subject::Sex::Male ? tr("Male") : Subject::Sex::Female ? tr("Female") : tr("Unknow");
    else if (role == DateOfBirth)
        return subject->dateOfBirth().toString("yyyy-MM-dd");
    else if (role == FamilyNumber)
        return subject->familyNumber();
    else if (role == UpdateDate)
        return subject->updateDate().toString("yyyy-MM-dd");
    else if (role == SearchField)
        return subject->searchField();
    return QVariant();
}


QHash<int, QByteArray> SubjectsListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Identifier] = "identifier";
    roles[Firstname] = "firstname";
    roles[Lastname] = "lastname";
    roles[Comment] = "comment";
    roles[Sex] = "sex";
    roles[DateOfBirth] = "dateOfBirth";
    roles[FamilyNumber] = "familyNumber";
    roles[UpdateDate] = "updateDate";
    roles[SearchField] = "searchField";
    return roles;
}
