#ifndef SAMPLESMANAGER_H
#define SAMPLESMANAGER_H

#include <QtCore>
#include "sample.h"
#include "Model/sortfilterproxymodel/samplesproxymodel.h"



class SamplesManager : public QAbstractListModel
{
    enum Roles
    {
        Id = Qt::UserRole + 1,
        Name,
        Nickname,
        IsMosaic,
        Comment,
        Status,
        Source,
        Subject,
        Reference,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int referencialId READ referencialId WRITE setReferenceId NOTIFY referencialIdChanged)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(SamplesProxyModel* proxy READ proxy NOTIFY proxyChanged)

public:
    explicit SamplesManager(QObject* parent = nullptr);
    explicit SamplesManager(int refId, QObject* parent = nullptr);

    // Property Get/Set
    inline int referencialId() const { return mRefId; }
    inline SamplesProxyModel* proxy() const { return mProxy; }
    void setReferenceId(int ref);

    // Methods
    Q_INVOKABLE Sample* getOrCreate(int sampleId, bool internalRefresh=false);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


public Q_SLOTS:
    // Called by NetworkManager when need to process WebSocket messages managed by SampleManager
    void processPushNotification(QString action, QJsonObject data);


Q_SIGNALS:
    // Property changed event
    void proxyChanged();
    void referencialIdChanged();
    void countChanged();
    void sampleImportStart(int fileId, QList<int> samplesIds);

private:
    //! The id of the current referencial (update sample list on change)
    int mRefId = -1;
    //! List of samples
    QList<Sample*> mSamplesList;
    //! Internal collection of all loaded samples
    QHash<int, Sample*> mSamples;
    //! The QSortFilterProxyModel to use by table view to browse samples of the manager
    SamplesProxyModel* mProxy;

};

#endif // SAMPLESMANAGER_H
