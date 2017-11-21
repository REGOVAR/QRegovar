#ifndef TOOLPARAMETER_H
#define TOOLPARAMETER_H


#include <QtCore>


class ToolParameter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString key READ key NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)
    Q_PROPERTY(QStringList enumValues READ enumValues NOTIFY dataChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY dataChanged)
    Q_PROPERTY(QVariant defaultValue READ defaultValue NOTIFY dataChanged)
    Q_PROPERTY(bool required READ required NOTIFY dataChanged)

public:
    explicit ToolParameter(QObject* parent = nullptr);
    explicit ToolParameter(QJsonObject json, QObject* parent = nullptr);

    // Getters
    inline QString key() const { return mKey; }
    inline QString name() const { return mName; }
    inline QString description() const { return mDescription; }
    inline QString type() const { return mType; }
    inline QStringList enumValues() const { return mEnumValues; }
    inline QVariant value() const { return mValue; }
    inline QVariant defaultValue() const { return mDefaultValue; }
    inline bool required() const { return mRequired; }

    // Setters
    inline void setValue(QVariant value) { mValue = value; emit dataChanged();}

    // Methods
    QJsonObject toJson();
    void clear();

Q_SIGNALS:
    void dataChanged();

private:
    QString mKey;
    QString mName;
    QString mDescription;
    QString mType;
    QStringList mEnumValues;
    QVariant mValue;
    QVariant mDefaultValue;
    bool mRequired = false;
};

#endif // TOOLPARAMETER_H
