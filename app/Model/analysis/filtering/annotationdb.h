#ifndef ANNOTATIONDB_H
#define ANNOTATIONDB_H

#include <QtCore>

class AnnotationDB : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid)
    Q_PROPERTY(QString name READ name NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(QString version READ version NOTIFY dataChanged)


public:
    AnnotationDB(QObject* parent=nullptr);

    // Getters
    inline QString uid() { return mUid; }
    inline QString name() { return mName; }
    inline QString description() { return mDescription; }
    inline QString version() { return mVersion; }

    // Methods
    Q_INVOKABLE bool fromJson(QJsonObject json);

Q_SIGNALS:
    void dataChanged();

private:
    QString mUid;
    QString mName;
    QString mDescription;
    QString mVersion;
};

#endif // ANNOTATIONDB_H
