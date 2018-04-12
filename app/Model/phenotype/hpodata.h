#ifndef HPODATA_H
#define HPODATA_H

#include <QtCore>

class HpoData: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString label READ label NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type  NOTIFY dataChanged)
    Q_PROPERTY(QStringList sources READ sources NOTIFY dataChanged)
    Q_PROPERTY(QStringList genes READ genes NOTIFY dataChanged)
    Q_PROPERTY(double genesFreq READ genesFreq NOTIFY dataChanged)
    Q_PROPERTY(double diseasesFreq READ diseasesFreq NOTIFY dataChanged)
    Q_PROPERTY(QString category READ category NOTIFY dataChanged)

    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)

public:
    // Constructor
    explicit HpoData(QObject* parent = nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString label() const { return mLabel; }
    inline QString type() const { return mType; }
    inline QStringList sources() const { return mSources; }
    inline QStringList genes() const { return mGenes; }
    inline double genesFreq() const { return mGenesFreq; }
    inline double diseasesFreq() const { return mDiseasesFreq; }
    inline QString category() const { return mCategory; }
    inline bool loaded() const { return mLoaded; }
    inline QString searchField() const { return mSearchField; }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE virtual bool fromJson(QJsonObject json) = 0;


Q_SIGNALS:
    void dataChanged();


protected:
    QString mId;
    QString mLabel;
    QString mType;
    QStringList mSources;
    QStringList mGenes;
    QString mCategory;
    double mGenesFreq;
    double mDiseasesFreq;
    bool mLoaded = false;
    QString mSearchField;
};

#endif // HPODATA_H
