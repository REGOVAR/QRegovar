#ifndef SAMPLESMANAGER_H
#define SAMPLESMANAGER_H

#include <QtCore>

class SamplesManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int referencialId READ referencialId WRITE setReferencialId NOTIFY referencialIdChanged)
    Q_PROPERTY(QList<QObject*> samplesList READ samplesList NOTIFY samplesListChanged)

public:
    explicit SamplesManager(QObject* parent = nullptr);
    explicit SamplesManager(int refId, QObject* parent = nullptr);

    // Getters
    inline int referencialId() const { return mRefId; }
    inline QList<QObject*> samplesList() const { return mSamplesList; }

    // Setters
    void setReferencialId(int ref);

Q_SIGNALS:
    // Property changed event
    void referencialIdChanged();
    void samplesListChanged();

private:
    //! The id of the current referencial (update sample list on change)
    int mRefId;
    //! List of samples
    QList<QObject*> mSamplesList;

};

#endif // SAMPLESMANAGER_H