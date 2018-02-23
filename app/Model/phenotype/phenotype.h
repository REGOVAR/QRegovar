#ifndef PHENOTYPE_H
#define PHENOTYPE_H

#include <QObject>

class Phenotype : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString label READ label NOTIFY dataChanged)
    Q_PROPERTY(QStringList genes READ genes NOTIFY dataChanged)
    Q_PROPERTY(QList<Phenotype*> relatedPhenotypes READ relatedPhenotypes NOTIFY dataChanged)
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)

public:
    // Constructor
    explicit Phenotype(QObject *parent = nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString label() const { return mLabel; }
    inline QStringList genes() const { return mGenes; }
    inline QList<Phenotype*> relatedPhenotypes() const { return mRelatedPhenotypes; }

    // Methods
    void fromJson(QJsonObject json);

Q_SIGNALS:
    void dataChanged();


private:
    QString mId;
    QString mLabel;
    QStringList mGenes;
    QList<Phenotype*> mRelatedPhenotypes;
    bool mLoaded = false;
};

#endif // PHENOTYPE_H
