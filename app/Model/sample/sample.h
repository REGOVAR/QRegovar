#ifndef SAMPLE_H
#define SAMPLE_H

#include <QObject>

class Sample : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(QString nickname READ nickname WRITE setNickname NOTIFY nicknameChanged)
public:
    explicit Sample(QObject *parent = nullptr);
    explicit Sample(int id, QString name, QString nickname, QObject *parent = nullptr);
    Sample(const Sample& other);
    ~Sample();

    // Getters
    inline int id() { return mId; }
    inline QString name() { return mName; }
    inline QString nickname() { return mNickname; }

    // Setters
    inline void setNickname(QString nickname) { mNickname = nickname; emit nicknameChanged(); }

Q_SIGNALS:
    void nicknameChanged();

public Q_SLOTS:

private:
    int mId;
    QString mName;
    QString mNickname;

};

#endif // SAMPLE_H
