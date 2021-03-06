#include "annotation.h"





Annotation::Annotation(QObject *parent) : QObject(parent)
{}

//Annotation::Annotation(const Annotation &other) : QObject(other.parent())
//{
//    mUid = other.mUid;
//    mDbUid = other.mDbUid;
//    mName = other.mName;
//    mDescription = other.mDescription;
//    mType = other.mType;
//    mMeta = other.mMeta;
//    mVersion = other.mVersion;
//    mOrder = other.mOrder;
//}

//Annotation::~Annotation()
//{}



Annotation::Annotation(QObject* parent, QString uid, QString dbUid, QString name, QString description,
                                 QString type, QJsonObject meta, QString version, QString dbName, int order)
: QObject(parent)
{
    mUid = uid;
    mDbUid = dbUid;
    mName = name;
    mDbName = dbName;
    mDescription = description;
    mType = type;
    mMeta = meta;
    mVersion = version;
    mOrder = order;
}






AnnotationDB::AnnotationDB(QObject* parent) : QObject(parent)
{
}

AnnotationDB::AnnotationDB(QString uid, QString name, QString description, QString version, bool isHeadVersion, QJsonArray fields, QObject* parent) : QObject(parent)
{
    mUid = uid;
    mName = name;
    mDescription = description;
    mVersion = version == "_all_" ? "" : version;
    mIsHeadVersion = isHeadVersion;
    setSelected(version == "_all_" ? true: isHeadVersion);

    for (const QJsonValue& data: fields)
    {
        QJsonObject a = data.toObject();
        QString fuid = a["uid"].toString();
        QString dbUid = a["dbuid"].toString();
        QString fname = a["name"].toString();
        QString fdesc = a["description"].toString();
        QString type = a["type"].toString();
        QJsonObject meta = a["meta"].toObject();
        Annotation* annot = new Annotation(this, fuid, dbUid, fname, fdesc, type, meta, mVersion, mName);

        mFields.append(annot);
    }

    emit dataChanged();
}
