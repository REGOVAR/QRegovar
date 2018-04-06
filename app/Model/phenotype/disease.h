#ifndef DISEASE_H
#define DISEASE_H

#include <QtCore>

class Disease: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString label READ label NOTIFY dataChanged)
    Q_PROPERTY(QStringList genes READ genes NOTIFY dataChanged)
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)


public:
    // Constructor
    explicit Disease(QObject* parent = nullptr);
    explicit Disease(QString hpoId, QObject* parent = nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString label() const { return mLabel; }
    inline QStringList genes() const { return mGenes; }
    inline bool loaded() const { return mLoaded; }
    inline QString searchField() const { return mSearchField; }

    // Method
    void fromJson(QJsonObject json);



Q_SIGNALS:
    void dataChanged();


public Q_SLOTS:
    void updateSearchField();


private:
    QString mId;
    QString mLabel;
    QStringList mGenes;
    bool mLoaded = false;
    QString mSearchField;
};

#endif // DISEASE_H
