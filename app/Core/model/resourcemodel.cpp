#include "resourcemodel.h"




ResourceModel::ResourceModel(QObject *parent) : QObject(parent)
{

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
