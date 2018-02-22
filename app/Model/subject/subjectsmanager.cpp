#include "subjectsmanager.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

SubjectsManager::SubjectsManager(QObject *parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Identifier);
}



void SubjectsManager::refresh()
{
    Request* request = Request::get("/subject");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            loadJson(json["data"].toArray());
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build subjects list model (due to request error)";
        }
        request->deleteLater();
    });
}
bool SubjectsManager::loadJson(QJsonArray json)
{
    beginResetModel();
    for (const QJsonValue& subjectVal: json)
    {
        QJsonObject subjectData = subjectVal.toObject();
        Subject* subject = getOrCreateSubject(subjectData["id"].toInt());
        subject->fromJson(subjectData);
    }
    endResetModel();
    return true;
}



Subject* SubjectsManager::getOrCreateSubject(int id)
{
    // Try to find subject in already know subjects
    if (mSubjects.contains(id))
    {
        return mSubjects[id];
    }
    // else
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    Subject* newSubject = new Subject(id, this);
    mSubjects.insert(id, newSubject);
    endInsertRows();
    return newSubject;
}



void SubjectsManager::newSubject(QString identifier, QString firstname, QString lastname, int sex, QString dateOfBirth, QString familyNumber, QString comment)
{
    QJsonObject body;
    body.insert("identifier", identifier);
    body.insert("firstname", firstname);
    body.insert("lastname", lastname);
    body.insert("sex", sex == 1 ? "male" : sex == 2 ? "female" : "unknow");
    body.insert("family_number", familyNumber);
    body.insert("comment", comment);
    if (!dateOfBirth.isEmpty()) body.insert("dateofbirth", regovar->dateFromShortString(dateOfBirth).toString(Qt::ISODate));

    Request* req = Request::post(QString("/subject"), QJsonDocument(body).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            Subject* subject = getOrCreateSubject(data["id"].toInt());
            subject->fromJson(data);
            openSubject(subject->id());
            emit subjectCreationDone(true, subject->id());

            refresh();
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
            emit subjectCreationDone(false, -1);
        }
        req->deleteLater();
    });
}



void SubjectsManager::openSubject(int id)
{
    // Get subject
    Subject* subject = getOrCreateSubject(id);
    // Refresh / get all information of the subject
    subject->load();
    // Notify the view via the update main menu with the subject's entry
    regovar->mainMenu()->openMenuEntry(subject);
}




int SubjectsManager::rowCount(const QModelIndex&) const
{
    return mSubjects.count();
}

QVariant SubjectsManager::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mSubjects.count())
        return QVariant();

    Subject* subject = mSubjects.values().at(index.row());
    if (subject->loaded())
    {
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
        else if (role == SearchField)
            return subject->searchField();
    }
    else
    {
        subject->load();
        return QVariant(tr("Data not loaded. Please refresh"));
    }
    return QVariant();
}

QHash<int, QByteArray> SubjectsManager::roleNames() const
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
    roles[SearchField] = "searchField";
    return roles;
}
