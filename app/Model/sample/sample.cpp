#include "sample.h"

Sample::Sample(QObject *parent) : QObject(parent)
{
}



Sample::Sample(int id, QString name, QString nickname, QObject *parent) : QObject(parent)
{
    mId = id;
    mName = name;
    mNickname = nickname;
}

Sample::Sample(const Sample& other) : QObject(other.parent())
{
    mId = other.mId;
    mName = other.mName;
    mNickname = other.mNickname;
}

Sample::~Sample()
{
}
