#ifndef SAVEDFILTER_H
#define SAVEDFILTER_H

#include <QtCore>

class SavedFilter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY idChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject filter READ filter WRITE setFilter NOTIFY dataChanged)
    Q_PROPERTY(int count READ count WRITE setCount NOTIFY dataChanged)
    Q_PROPERTY(double progress READ count WRITE setProgress NOTIFY dataChanged)


public:
    SavedFilter(QObject* parent = nullptr);

    // Getters
    inline int id() { return mId; }
    inline QString name() { return mName; }
    inline QString description() { return mDescription; }
    inline QJsonObject filter() { return mFilter; }
    inline int count() { return mCount; }
    inline double progress() { return mProgress; }

    // Setters
    inline void setName(QString name) { mName = name; emit dataChanged(); }
    inline void setDescription(QString desc) { mDescription = desc; emit dataChanged(); }
    inline void setFilter(QJsonObject filter) { mFilter= filter; emit dataChanged(); }
    inline void setCount(int count) { mCount = count; emit dataChanged(); }
    inline void setProgress(double prog) { mProgress = prog; emit dataChanged(); }

Q_SIGNALS:
    void idChanged();
    void dataChanged();

private:
    int mId;
    QString mName;
    QString mDescription;
    QJsonObject mFilter;
    int mCount;
    double mProgress;
};

#endif // SAVEDFILTER_H
