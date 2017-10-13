#ifndef FREQUENCEQUICKFILTER_H
#define FREQUENCEQUICKFILTER_H


#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"

class FrequenceQuickFilter : public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> _1000G READ _1000G)
    Q_PROPERTY(QList<QObject*> exac READ exac)

public:
    explicit FrequenceQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible();
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant());
    Q_INVOKABLE void clear();
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs);
    bool loadJson(QJsonArray filter);

    inline QList<QObject*> _1000G() { return m1000GFields; }
    inline QList<QObject*> exac() { return mExacFields; }
    void init(QStringList _1000g, QStringList exac);


private:
    QList<QObject*> m1000GFields;
    QList<QObject*> mExacFields;
    QString mFilter;
    QStringList mOperators;
    QHash<QString, QString> mOpMapping;

    bool mIsVisible;

    QHash<QString,QString> mFieldsNames;
};

#endif // FREQUENCEQUICKFILTER_H
