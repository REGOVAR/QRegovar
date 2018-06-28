#ifndef FILTERINGRESULTCELL_H
#define FILTERINGRESULTCELL_H

#include <QtCore>
#include <QColor>

class FilteringResultCell : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)

public:
    // Constructors
    FilteringResultCell(QObject *parent = nullptr);

    // Getters
    inline QString uid() { return mUid; }

    // Setters
    inline void setUid(const QString& uid) { mUid = uid; emit uidChanged(); }

Q_SIGNALS:
    void uidChanged();

private:
    QString mUid;
};

#endif // FILTERINGRESULTCELL_H
