#ifndef SAMPLESMANAGER_H
#define SAMPLESMANAGER_H

#include <QtCore>
#include "sample.h"
#include "Model/framework/genericproxymodel.h"

class FilteringAnalysis;
class Subject;

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
        Subj, // Subject
        Reference,
        SearchField
    };

    Q_OBJECT
    Q_PROPERTY(int referencialId READ referencialId WRITE setReferenceId NOTIFY referencialIdChanged)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(GenericProxyModel* proxy READ proxy NOTIFY neverChanged)

public:
    // Constructor
    SamplesManager(QObject* parent = nullptr);
    SamplesManager(int refId, QObject* parent = nullptr);

    // Property Get/Set
    inline int referencialId() const { return mRefId; }
    inline GenericProxyModel* proxy() const { return mProxy; }
    void setReferenceId(int ref);

    // Methods
    Q_INVOKABLE Sample* getOrCreateSample(int sampleId, bool internalRefresh=false);
    bool loadJson(const QJsonArray& json);
    //! Ask server to import samples from fileId. Emit sampleImportStart
    Q_INVOKABLE void importFromFile(int fileId, int refId, FilteringAnalysis* analysis=nullptr, Subject* subject=nullptr);

    // QAbstractListModel methods
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;


public Q_SLOTS:
    // Called by NetworkManager when need to process WebSocket messages managed by SampleManager
    void processPushNotification(QString action, QJsonObject data);


Q_SIGNALS:
    void neverChanged();
    // Property changed event
    void referencialIdChanged();
    void countChanged();
    void sampleImportStart(int fileId, QList<int> samplesIds);


public Q_SLOTS:
    void propagateDataChanged();


private:
    //! The id of the current referencial (update sample list on change)
    int mRefId = -1;
    //! List of samples
    QList<Sample*> mSamplesList;
    //! Internal collection of all loaded samples
    QHash<qint64, Sample*> mSamples;
    //! The QSortFilterProxyModel to use by table view to browse samples of the manager
    GenericProxyModel* mProxy = nullptr;

};

#endif // SAMPLESMANAGER_H
