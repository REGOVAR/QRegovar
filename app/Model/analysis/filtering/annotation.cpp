#include "annotation.h"


Annotation::Annotation(QObject *parent) : QObject(parent)
{}

Annotation::Annotation(const Annotation &other) : QObject(other.parent())
{
    mUid = other.mUid;
    mDbUid = other.mDbUid;
    mName = other.mName;
    mDescription = other.mDescription;
    mType = other.mType;
    mMeta = other.mMeta;
    mVersion = other.mVersion;
    mOrder = other.mOrder;
}

Annotation::~Annotation()
{}



Annotation::Annotation(QObject* parent, QString uid, QString dbUid, QString name, QString description,
                                 QString type, QJsonObject meta, QString version, int order)
: QObject(parent)
{
    mUid = uid;
    mDbUid = dbUid;
    mName = name;
    mDescription = description;
    mType = type;
    mMeta = meta;
    mVersion = version;
    mOrder = order;
}
