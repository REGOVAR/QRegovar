#ifndef FILTER_H
#define FILTER_H

#include <QtCore>

class Filter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(QString description READ description)
    Q_PROPERTY(int count READ count)

public:
    Filter(QObject* parent=nullptr);
    Filter(int id, QString name, QString description, QString qFilter, QString filter, int count, QObject* parent=nullptr);

    // Getters
    inline QString name() { return mName; }
    inline QString description() { return mDescription; }
    inline int count() { return mCount; }

    // Method
    bool fromJson(QJsonObject json);

private:
    int mId;
    QString mName;
    QString mDescription;
    int mCount;
    QString mQFilter;
    QString mFilter;
};

#endif // FILTER_H
