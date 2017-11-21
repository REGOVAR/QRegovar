#ifndef TOOL_H
#define TOOL_H

#include <QtCore>
#include "toolparameter.h"

class Tool : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString key READ key NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> parameters READ parameters NOTIFY dataChanged)

public:
    explicit Tool(QObject* parent = nullptr);
    explicit Tool(QJsonObject json, QObject* parent = nullptr);

    // Getters
    inline QString key() { return mKey; }
    inline QString name() { return mName; }
    inline QString description() { return mDescription; }
    inline QList<QObject*> parameters() { return mParameters; }

    // Methods
    QJsonObject toJson();
    void clear();

Q_SIGNALS:
    void dataChanged();

private:
    QString mKey;
    QString mName;
    QString mDescription;
    QList<QObject*> mParameters;
};

#endif // TOOL_H
