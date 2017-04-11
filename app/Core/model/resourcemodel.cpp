#include "resourcemodel.h"




ResourceModel::ResourceModel() : QObject(0)
{
}
ResourceModel::ResourceModel(quint32 id) : QObject(0)
{
     mId = id;
}


bool ResourceModel::isValid() const
{
    return mId != -1;
}



quint32 ResourceModel::id() const
{
    return mId;
}
void ResourceModel::setId(quint32 id)
{
    mId = id;
}
