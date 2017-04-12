#include "resourcemodel.h"




ResourceModel::ResourceModel(QObject* parent) : QObject(parent)
{
}
ResourceModel::ResourceModel(quint32 id, QObject* parent) : QObject(parent), mId(id)
{
}


bool ResourceModel::isValid() const
{
    return mId != 0;
}



quint32 ResourceModel::id() const
{
    return mId;
}
void ResourceModel::setId(quint32 id)
{
    mId = id;
}
