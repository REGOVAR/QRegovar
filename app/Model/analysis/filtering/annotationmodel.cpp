#include "annotationmodel.h"


AnnotationModel::AnnotationModel(QObject *parent) : QObject(parent)
{}

AnnotationModel::AnnotationModel(const AnnotationModel &other) : QObject(other.parent())
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

AnnotationModel::~AnnotationModel()
{}



AnnotationModel::AnnotationModel(QObject* parent, QString uid, QString dbUid, QString name, QString description,
                                 QString type, QString meta, QString version, int order)
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
