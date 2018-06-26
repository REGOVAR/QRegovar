#ifndef SERVERTASK_H
#define SERVERTASK_H

#include <QtCore>
#include "Model/framework/regovarresource.h"

class ServerTask : public RegovarResource
{    
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString status READ status NOTIFY dataChanged) // done, running, pause
    Q_PROPERTY(QString type READ type NOTIFY dataChanged) // upload, pipeline, analysis
    Q_PROPERTY(QString label READ label NOTIFY dataChanged)
    Q_PROPERTY(float progress READ progress NOTIFY dataChanged)
    Q_PROPERTY(bool enableControls READ enableControls NOTIFY dataChanged)
    Q_PROPERTY(QDateTime lastUpdate READ lastUpdate NOTIFY dataChanged)


public:
    // Constructor
    ServerTask(QObject* parent=nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString status() const { return mStatus; }
    inline QString type() const { return mType; }
    inline QString label() const { return mLabel; }
    inline float progress() const { return mProgress; }
    inline bool enableControls() const { return mEnableControls; }
    inline QDateTime lastUpdate() const { return mLastUpdate; }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;
    Q_INVOKABLE void pause();
    Q_INVOKABLE void cancel();
    Q_INVOKABLE void open();



public Q_SLOTS:
    void updateSearchField() override;

private:
    QString mId;
    int mInternalId = -1;
    QString mStatus;
    QString mType;
    QString mLabel;
    float mProgress = 0;
    bool mEnableControls = false;
    QDateTime mLastUpdate;
};

#endif // SERVERTASK_H
