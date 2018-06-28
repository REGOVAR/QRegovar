#ifndef REGOVARRESOURCE_H
#define REGOVARRESOURCE_H

#include <QtCore>

class RegovarResource: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)

public:
    // Constructors
    RegovarResource(QObject* parent=nullptr);

    // Getters
    inline bool loaded() const { return mLoaded; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QDateTime createDate() const { return mCreateDate; }
    inline QString searchField() const { return mSearchField; }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE virtual bool loadJson(const QJsonObject& json, bool full_init=true);
    //! Export model data into json object
    Q_INVOKABLE virtual QJsonObject toJson();
    //! Save resource information onto server
    Q_INVOKABLE virtual void save();
    //! Load resource information from server
    Q_INVOKABLE virtual void load(bool forceRefresh=true);


public Q_SLOTS:
    virtual void updateSearchField();


Q_SIGNALS:
    void dataChanged();

protected:
    bool mLoaded = false;
    QDateTime mUpdateDate;
    QDateTime mCreateDate;
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();
    QString mSearchField;
};

#endif // REGOVARRESOURCE_H
