#ifndef ONTOLOGYQUICKFILTER_H
#define ONTOLOGYQUICKFILTER_H

#include <QObject>
#include <QVariant>
#include <QHash>
#include "quickfilterblockinterface.h"


class OntologyQuickFilter: public QuickFilterBlockInterface
{
    Q_OBJECT
    Q_PROPERTY(QuickFilterField* _1000GAll READ _1000GAll)
    Q_PROPERTY(QuickFilterField* exacAll READ exacAll)
    Q_PROPERTY(QList<QObject*> _1000G READ _1000G)
    Q_PROPERTY(QList<QObject*> exac READ exac)

public:
    explicit OntologyQuickFilter(int analysisId);

    Q_INVOKABLE bool isVisible() override;
    Q_INVOKABLE QJsonArray toJson() override;
    Q_INVOKABLE void setFilter(QString filterId, bool filterActive, QVariant filterValue=QVariant()) override;
    Q_INVOKABLE void clear() override;
    Q_INVOKABLE void checkAnnotationsDB(QList<QObject*> dbs) override;
    bool loadJson(QJsonArray filter) override;

    inline QList<QObject*> _1000G() { return m1000GFields; }
    inline QList<QObject*> exac() { return mExacFields; }
    inline QuickFilterField* _1000GAll() { return m1000GAll; }
    inline QuickFilterField* exacAll() { return mExacAll; }
    void init(QString _1000gUid, QString exacUid, QStringList _1000g, QStringList exac);


private:
    QuickFilterField* m1000GAll = nullptr;
    QuickFilterField* mExacAll = nullptr;
    QList<QObject*> m1000GFields;
    QList<QObject*> mExacFields;
    QString mFilter;
    QStringList mOperators;
    QHash<QString, QString> mOpMapping;

    bool mIsVisible;

    QHash<QString,QString> mFieldsNames;
};

#endif // ONTOLOGYQUICKFILTER_H
