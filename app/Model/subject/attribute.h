#ifndef ATTRIBUTE_H
#define ATTRIBUTE_H


#include <QtCore>
#include "Model/analysis/filtering/filteringanalysis.h"
#include "Model/subject/sample.h"

//! Sample attribute model
class Attribute : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY attributeChanged)
    Q_PROPERTY(QHash<int, QString> samplesValues READ samplesValues NOTIFY attributeChanged)


public:
    // Constructors
    explicit Attribute(QObject* parent = nullptr);
    explicit Attribute(QString name);
    explicit Attribute(QJsonObject json);

    // Getters
    inline QString name() const { return mName; }
    inline QHash<int, QString> samplesValues() const { return mSamplesValues; }
    inline QHash<QString, QString> getMapping() { return mMapping; }

    // Setters
    inline void setName(QString n) { mName = n; emit attributeChanged(); }

    // Methods
    Q_INVOKABLE inline QString getValue(int sampleId) { return mSamplesValues[sampleId]; }
    Q_INVOKABLE inline void setValue(int sampleId, QString value) { mSamplesValues[sampleId] = value; }
    Q_INVOKABLE QJsonObject toJson();
    Q_INVOKABLE bool loadJson(QJsonObject json);


Q_SIGNALS:
    void attributeChanged();


private:
    //! Attribute name
    QString mName;
    //! Mapping between sample's id and attribute value
    QHash<int, QString> mSamplesValues;
    //! Hold the mapping value -> wt_col_id. This mapping is only available when loading analysis from server json
    QHash<QString, QString> mMapping;
};

#endif // ATTRIBUTE_H
