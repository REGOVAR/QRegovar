#include "subjectsmanager.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

SubjectsManager::SubjectsManager(QObject *parent) : QObject(parent)
{
}



void SubjectsManager::refreshSubjectsList()
{
    Request* request = Request::get("/subject");
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mSubjectsList.clear();
            QJsonArray data = json["data"].toArray();
            foreach (QJsonValue subjectVal, data)
            {
                mSubjectsList.append(new Subject(subjectVal.toObject()));
            }
            emit subjectsListChanged();
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build subjects list model (due to request error)";
        }
        request->deleteLater();
    });
}



Subject* SubjectsManager::getOrCreateSubject(int id)
{
    // Try to find subject in already know subjects
    foreach (QObject* o, mSubjectsList)
    {
        Subject* s = qobject_cast<Subject*>(o);
        if (s->id() == id)
        {
            return s;
        }
    }
    // else
    Subject* newSubject = new Subject(id);
    mSubjectsList.append(newSubject);
    return newSubject;
}



void SubjectsManager::newSubject(QString identifier, QString firstname, QString lastname, int sex, QString dateOfBirth, QString familyNumber, QString comment)
{
    QJsonObject body;
    body.insert("identifier", identifier);
    body.insert("firstname", firstname);
    body.insert("lastname", lastname);
    body.insert("sex", sex == 1 ? "male" : sex == 2 ? "female" : "unknow");
    body.insert("dateOfBirth", dateOfBirth);
    body.insert("familyNumber", familyNumber);
    body.insert("comment", comment);

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

            refreshSubjectsList();
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
    // Set ref index
    mSubjectOpenIndex = mSubjectsOpenList.indexOf(subject);
    if (mSubjectOpenIndex == -1)
    {
        mSubjectsOpenList.insert(0, subject);
        mSubjectOpenIndex = 0;
        mSubjectOpen = qobject_cast<Subject*>(mSubjectsOpenList[mSubjectOpenIndex]);
        emit subjectsOpenListChanged();
    }
    // Set ref object
    mSubjectOpen = qobject_cast<Subject*>(mSubjectsOpenList[mSubjectOpenIndex]);
    // notify view
    emit subjectOpenChanged(mSubjectOpenIndex);
}


void SubjectsManager::setSearchQuery(QString)
{
    // TODO : update mSubjectsList according to filter
    emit searchQueryChanged();
    emit subjectsListChanged();
}
