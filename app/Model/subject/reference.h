#ifndef REFERENCE_H
#define REFERENCE_H

#include <QtCore>

class Reference : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)


public:
    Reference(QObject* parent=nullptr);

    // Getters
    inline int id() { return mId; }
    inline QString name() { return mName; }

    // Setters
    inline void setName(QString name) { mName = name; emit dataChanged(); }

    // Methods
    Q_INVOKABLE bool fromJson(QJsonObject json);

Q_SIGNALS:
    void dataChanged();

private:
    QString mName;
    int mId;
};

#endif // REFERENCE_H
