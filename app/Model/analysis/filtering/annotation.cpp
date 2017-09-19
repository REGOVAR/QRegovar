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






AnnotationDB::AnnotationDB(QObject* parent) : QObject(parent)
{
}

AnnotationDB::AnnotationDB(QString name, QString description, QString version, bool isDefault, QJsonArray fields, QObject* parent) : QObject(parent)
{
    mName = name;
    mDescription = description;
    mVersion = version == "_all_" ? "" : version;
    mDefault = isDefault;
    setSelected(version == "_all_" ? true: isDefault);

    foreach (const QJsonValue data, fields)
    {
        QJsonObject a = data.toObject();
        QString uid = a["uid"].toString();
        QString dbUid = a["dbuid"].toString();
        QString name = a["name"].toString();
        QString description = a["description"].toString();
        QString type = a["type"].toString();
        QJsonObject meta = a["meta"].toObject();
        Annotation* annot = new Annotation(this, uid, dbUid, name, description, type, meta, "");

        mFields.append(annot);
    }
}
