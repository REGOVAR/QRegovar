#include "panel.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "Model/phenotype/geneslistmodel.h"



Panel::Panel(QObject* parent) : RegovarResource(parent)
{
    connect(this, &Panel::dataChanged, this, &Panel::updateSearchField);
    mVersions = new PanelVersionsListModel(this);
}
Panel::Panel(QJsonObject json, QObject* parent) : Panel(parent)
{
    loadJson(json);
}



void Panel::updateSearchField()
{
    mSearchField = mName + " " + mDescription + " " + mOwner;
}


// Load only data for the current panelversion.
bool Panel::loadJson(const QJsonObject& json, bool)
{
    // Loading Panels information


    mId = json["id"].toString();
    mName = json["name"].toString();
    mOwner = json["owner"].toString();
    mDescription = json["description"].toString();
    mShared = json["shared"].toBool();
    mCreateDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);

    // Create all other versions of the same panel
    int order = 0;
    for (const QJsonValue& data: json["versions"].toArray())
    {
        PanelVersion* version = mVersions->addVersion(data.toObject(), false);
        version->setOrder(order--);
        connect(version, &PanelVersion::dataChanged, this, &Panel::updateSearchField);
    }

    emit dataChanged();
    return true;
}

QJsonObject Panel::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("name", mName);
    result.insert("owner", mOwner);
    result.insert("description", mDescription);
    result.insert("shared", mShared);


    // Versions
    // Notice: in case of the user only update panel's information, we don't send version
    // data to the server. To avoid to create wrong version

    // To save a new version, need to call dedicated Panel method: Panel::saveNewVersion()

    return result;
}




void Panel::reset(Panel* panel)
{
    // reset all (case of new panel creation)
    mId = "";
    mName = "";
    mDescription = "";
    mOwner = "";
    mShared = false;
    headVersion()->reset(panel);
    // init with provided panel version information (case of new panel version creation)
    if (panel != nullptr)
    {
        mId = panel->id();
        mName = panel->name();
        mDescription = panel->description();
        mOwner = panel->owner();
        mShared = panel->shared();
    }
}



void Panel::addEntry(QJsonObject json)
{
    PanelVersion* head = headVersion();
    if (head != nullptr)
    {
        head->addEntry(json);
    }
    else
    {
        qDebug() << "WARNING: No panel head version";
    }
}

void Panel::addEntriesFromHpo(QString id)
{
    PanelVersion* head = headVersion();
    HpoData* hpo = regovar->phenotypesManager()->getOrCreate(id);
    if (head != nullptr)
    {
        if (hpo->loaded())
        {
            importGenesFromHpoData();
        }
        else
        {
            mTmpHpo = hpo;
            connect(hpo, &HpoData::dataChanged, this, &Panel::importGenesFromHpoData);
            hpo->load();
        }
    }
    else
    {
        qDebug() << "WARNING: No panel head version";
    }
}


void Panel::importGenesFromHpoData()
{
    PanelVersion* head = headVersion();
    if (mTmpHpo != nullptr)
    {
        for(int idx=0; idx < mTmpHpo->genes()->rowCount(); idx ++)
        {
            QJsonObject entry = mTmpHpo->genes()->getAt(idx)->toJson();
            entry.insert("details", tr("From HPO entry: ") + mTmpHpo->label());
            entry.insert("type", "gene");
            head->addEntry(entry);
        }
        disconnect(mTmpHpo, &HpoData::dataChanged, this, &Panel::importGenesFromHpoData);
        mTmpHpo = nullptr;
    }
}




void Panel::save()
{
    if (mId.isEmpty()) return;
    Request* request = Request::put(QString("/panel/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Panel saved";
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        request->deleteLater();
    });
}



void Panel::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (!mLoaded || forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/panel/%1").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                loadJson(json["data"].toObject());
                mLoaded = true;
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}











