#include "subject.h"
#include "sample.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "Model/event/eventslistmodel.h"

Subject::Subject(QObject* parent) : QObject(parent)
{
    mPhenotypes = new HpoDataListModel(this);
}

Subject::Subject(QJsonObject json, QObject* parent) : Subject(parent)
{
    fromJson(json, false);
}
Subject::Subject(int id, QObject* parent) : QObject(parent)
{
    mId = id;
    mPhenotypes = new HpoDataListModel(id, this);
}



bool Subject::fromJson(QJsonObject json, bool full_init)
{
    mId = json["id"].toInt();
    mIdentifier = json["identifier"].toString();
    mFirstname = json["firstname"].toString();
    mLastname = json["lastname"].toString();
    mComment = json["comment"].toString();
    mFamilyNumber = json["family_number"].toString();
    QString sex = json["sex"].toString();
    mSex = sex == "male" ? Sex::Male : "female" ?  Sex::Female : Sex::Unknow;
    mDateOfBirth = QDate::fromString(json["dateofbirth"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);
    mCreateDate = QDateTime::fromString(json["create_date"].toString(), Qt::ISODate);
    mEvents = new EventsListModel("subject_id", QString::number(mId));

    updateSubjectUI();
    updateSearchField();

    if (!full_init) return true;

    mPhenotypes->clear();
    mSamples.clear();
    mAnalyses.clear();
    mProjects.clear();
    mJobs.clear();
    mFiles.clear();
    mIndicators.clear();

    // samples
    for (const QJsonValue& val: json["samples"].toArray())
    {
        QJsonObject sampleData = val.toObject();
        Sample* sample = regovar->samplesManager()->getOrCreateSample(sampleData["id"].toInt());
        sample->fromJson(sampleData);
        mSamples.append(sample);
    }
    // Phenotype
    for (const QJsonValue& val: json["hpo"].toArray())
    {
        QJsonObject data = val.toObject();
        HpoData* hpo = regovar->phenotypesManager()->getOrCreate(data["id"].toString());
        hpo->fromJson(data);
        if (data.contains("presence"))
        {
            setPresence(hpo->id(), data["presence"].toString());
        }
        mPhenotypes->add(hpo);
    }

    // Event
    mEvents->loadJson(json["events"].toArray());


    mLoaded = true;
    emit dataChanged();
    return true;
}



QJsonObject Subject::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("identifier", mIdentifier);
    result.insert("firstname", mFirstname);
    result.insert("lastname", mLastname);
    result.insert("dateofbirth", mDateOfBirth.toString(Qt::ISODate));
    result.insert("family_number", mFamilyNumber);
    result.insert("comment", mComment);
    result.insert("sex", mSex == Sex::Male ? "male" : mSex == Sex::Female ? "female" : "unknow");
    // Samples
    QJsonArray samples;
    for (QObject* o: mSamples)
    {
        Sample* sample = qobject_cast<Sample*>(o);
        samples.append(sample->id());
    }
    result.insert("samples_ids", samples);
    // Phenotype
    QJsonArray hpo;
    for (int i=0; i<mPhenotypes->rowCount() ; ++i)
    {
        QString id = mPhenotypes->getAt(i)->id();
        hpo.append((presence(id) == "present" ? "+" : "-" )+ id);
    }
    result.insert("hpo_ids", hpo);

    // Files
    // Indicators

    return result;
}



void Subject::save()
{
    if (mId == -1) return;
    Request* request = Request::put(QString("/subject/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Subject saved";
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        request->deleteLater();
    });
}



void Subject::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (!mLoaded || forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/subject/%1").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                fromJson(json["data"].toObject());
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}



void Subject::addSample(Sample* sample)
{
    // Check that sample not already in the list
    for (QObject* o: mSamples)
    {
        Sample* s = qobject_cast<Sample*>(o);
        if (s->id() == sample->id()) return;
    }

    // Add sample to the subject
    mSamples.append(sample);
    emit dataChanged();

    // add subject to the sample
    sample->setSubject(this);
    sample->save();
}


void Subject::removeSample(Sample* sample)
{
    // Check that sample already in the list
    mSamples.removeAll(sample);
    emit dataChanged();

    // remove subject to the sample
    sample->setSubject(nullptr);
    sample->save();
}


void Subject::setHpo(HpoData* hpo, QString presence)
{
    if (hpo != nullptr)
    {
        mPhenotypes->add(hpo);
        setPresence(hpo->id(), presence);
    }
}


void Subject::removeHpo(HpoData* phenotype)
{
    if (mPhenotypes->remove(phenotype))
    {
        save();
        emit dataChanged();
    }
}



QString Subject::presence(QString hpoId) const
{
    if (mPresence.contains(hpoId))
        return mPresence[hpoId];
    return "unknow";
}
void Subject::setPresence(QString hpoId, QString presence)
{
    if (mPresence.contains(hpoId))
    {
        mPresence[hpoId] = presence;
        save();
        emit dataChanged();
    }
}

QDateTime Subject::additionDate(QString hpoId) const
{
    if (mAdditionDate.contains(hpoId))
        return mAdditionDate[hpoId];
    return QDateTime();
}





void Subject::updateSubjectUI()
{
    // Format name
    QString name = mIdentifier;
    if (!mLastname.isEmpty() && !mFirstname.isEmpty())
    {
        name += ": " + mFirstname +" " + mLastname.toUpper();
    }

    // Format result
    mSubjectUI.insert("id", mId);
    mSubjectUI.insert("name", name);
    mSubjectUI.insert("age", computeAge(mDateOfBirth, QDate::currentDate()));
    mSubjectUI.insert("sex", mSex == Male ? "9" : Female ? "<" : "f");
}



QString Subject::computeAge(QDate d1, QDate d2)
{
    QDateTime beginDate(d1, QTime(8, 00, 0));
    QDateTime expireDate(d2, QTime(8, 00, 0));
    int y=0, m=0, d=0;

    if (beginDate.daysTo(expireDate) >= 0)
    {
        y = expireDate.date().year() - beginDate.date().year();
        m = expireDate.date().month() - beginDate.date().month();
        if (m < 0)
        {
            y--;
            m += 12;
        }
        d = expireDate.date().day() - beginDate.date().day();
        if (d<0)
        {
            if (--m < 0)
            {
                y--;
                m += 12;
            }
            d += beginDate.date().daysInMonth();
        }
    }

    QString age;
    if (y > 0) age += QString::number(y) + (y > 1 ? tr("years") : tr("year")) + " ";
    if (m > 0) age += QString::number(m) + (m > 1 ? tr("months") : tr("month")) + " ";
    if (d > 0) age += QString::number(d) + (d > 1 ? tr("days") : tr("day"));
    return age.trimmed();
}




void Subject::updateSearchField()
{
    mSearchField = mIdentifier + " " + mFirstname + " " + mLastname + " " + mDateOfBirth.toString("yyyy-MM-dd HH:mm");
    mSearchField += " " + mComment + " " + mFamilyNumber + mSex == Male ? "Male" : Female ? "Female" : "";
}
