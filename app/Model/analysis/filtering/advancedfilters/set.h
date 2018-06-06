#ifndef SET_H
#define SET_H

#include <QtCore>
#include "Model/analysis/filtering/filteringanalysis.h"

class Set : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(FilteringAnalysis* analysis READ analysis NOTIFY setChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY setChanged)
    Q_PROPERTY(QString id READ id WRITE setId NOTIFY setChanged)
    Q_PROPERTY(QString label READ label NOTIFY setChanged)

public:
    // Constructors
    Set(QObject* parent = nullptr);
    Set(QString type, QString id, QString label);

    // Getters
    //inline FilteringAnalysis* analysis() const { return mAnalysis; }
    inline QString type() const { return mType; }
    inline QString id() const { return mId; }
    inline QString label() const { return mLabel; }
    // Setters
    inline void setType(QString type) { mType = type; emit setChanged(); }
    inline void setId(QString id) { mId = id; emit setChanged(); }

    // Methods
    //Q_INVOKABLE virtual void loadJson(QJsonArray filterJson);
    Q_INVOKABLE virtual QJsonArray toJson();


Q_SIGNALS:
    void setChanged();

private:
    QString mType;
    QString mId;
    QString mLabel;
};

#endif // SET_H
