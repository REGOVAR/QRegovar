#ifndef SAMPLESMANAGER_H
#define SAMPLESMANAGER_H

#include <QtCore>
#include "sample.h"

class SamplesManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int referencialId READ referencialId WRITE setReferenceId NOTIFY referencialIdChanged)
    Q_PROPERTY(QList<QObject*> samplesList READ samplesList NOTIFY samplesListChanged)

public:
    explicit SamplesManager(QObject* parent = nullptr);
    explicit SamplesManager(int refId, QObject* parent = nullptr);

    // Getters
    inline int referencialId() const { return mRefId; }
    inline QList<QObject*> samplesList() const { return mSamplesList; }

    // Setters
    void setReferenceId(int ref);

    // Methods
    Sample* getOrCreate(int sampleId);

public Q_SLOTS:
    // Called by NetworkManager when need to process WebSocket messages managed by SampleManager
    void processPushNotification(QString action, QJsonObject data);


Q_SIGNALS:
    // Property changed event
    void referencialIdChanged();
    void samplesListChanged();

private:
    //! The id of the current referencial (update sample list on change)
    int mRefId = -1;
    //! List of samples
    QList<QObject*> mSamplesList;
    //! internal collection of all loaded samples
    QHash<int, Sample*> mSamples;

};

#endif // SAMPLESMANAGER_H
