#ifndef SERVERTASK_H
#define SERVERTASK_H

#include <QtCore>
#include "Model/framework/regovarresource.h"

class ServerTask : public RegovarResource
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString status READ status NOTIFY dataChanged)
    Q_PROPERTY(QString label READ label NOTIFY dataChanged)
    Q_PROPERTY(float progress READ progress NOTIFY dataChanged)
    Q_PROPERTY(QDateTime lastUpdate READ lastUpdate NOTIFY dataChanged)


public:
    // Constructor
    ServerTask(QObject* parent=nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString status() const { return mStatus; }
    inline QString label() const { return mLabel; }
    inline float progress() const { return mProgress; }
    inline QDateTime lastUpdate() const { return mLastUpdate; }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;



public Q_SLOTS:
    void updateSearchField() override;

private:
    QString mId;
    QString mStatus;
    QString mLabel;
    float mProgress = 0;
    QDateTime mLastUpdate;
};

#endif // SERVERTASK_H
