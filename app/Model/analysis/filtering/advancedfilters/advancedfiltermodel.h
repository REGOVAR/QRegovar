#ifndef CONDITIONBLOCK_H
#define CONDITIONBLOCK_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>

#include "Model/analysis/filtering/annotation.h"
#include "Model/regovar.h"



class AdvancedFilterModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString qmlId READ qmlId NOTIFY qmlIdChanged)
    Q_PROPERTY(ConditionType type READ type WRITE setType NOTIFY filterChanged)
    Q_PROPERTY(QString leftOp READ leftOp WRITE setLeftOp NOTIFY filterChanged)
    Q_PROPERTY(QString rightOp READ rightOp WRITE setRightOp NOTIFY filterChanged)
    Q_PROPERTY(QString op READ op WRITE setOp NOTIFY filterChanged)
    Q_PROPERTY(int opIndex READ opIndex WRITE setOpIndex NOTIFY filterChanged)
    Q_PROPERTY(QList<QObject*> subConditions READ subConditions NOTIFY filterChanged)
    Q_PROPERTY(QStringList opList READ opList NOTIFY filterChanged)
    Q_PROPERTY(QStringList enumList READ enumList NOTIFY filterChanged)
    Q_PROPERTY(QString fieldUid READ fieldUid WRITE setFieldUid NOTIFY filterChanged)
    Q_PROPERTY(QString fieldType READ fieldType NOTIFY filterChanged)
    Q_PROPERTY(QVariant fieldValue READ fieldValue WRITE setFieldValue NOTIFY filterChanged)

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool collapsed READ collapsed WRITE setCollapsed NOTIFY collapsedChanged)


public:
    enum ConditionType
    {
        LogicalBlock = 0,
        FieldBlock,
        SetBlock
    };
    Q_ENUM(ConditionType)

    // Constructor
    explicit AdvancedFilterModel(QObject* parent=nullptr);
    explicit AdvancedFilterModel(FilteringAnalysis* parent);
    explicit AdvancedFilterModel(QJsonArray filterJson, FilteringAnalysis* parent);

    // Getters
    inline QString qmlId() const { return mQmlId; }
    inline ConditionType type() const { return mType; }
    inline QString leftOp() const { return mLeftOp; }
    inline QString rightOp() const { return mRightOp; }
    inline QString op() const { return mOp; }
    inline int opIndex() const { return mOpIndex; }
    inline QList<QObject*> subConditions() const { return mSubConditions; }
    inline QStringList opList() const { return mOpList; }
    inline QStringList enumList() const { return mEnumList; }
    inline QString fieldUid() const { return mField->uid(); }
    inline QString fieldType() const { return mField->type(); }
    inline QVariant fieldValue() const { return mFieldValue; }

    inline bool enabled() const { return mEnabled; }
    inline bool collapsed() const { return mCollapsed; }

    // Setters
    void setType(ConditionType type);
    inline void setLeftOp(QString op) { mLeftOp = op; emit filterChanged(); }
    inline void setRightOp(QString op) { mRightOp = op; emit filterChanged(); }
    inline void setOp(QString op) { mOp = op; emit filterChanged(); }
    inline void setOpIndex(int opIdx) { mOpIndex = opIdx; emit filterChanged(); }
    void setFieldUid(QString fieldUid);
    inline void setFieldValue(QVariant val) { mFieldValue = val; emit filterChanged(); }
    inline void setEnabled(bool flag) { mEnabled = flag; emit enabledChanged(); }
    inline void setCollapsed(bool flag) { mCollapsed = flag; emit collapsedChanged(); }

    // Methods
    Q_INVOKABLE void loadJson(QJsonArray filterJson);
    Q_INVOKABLE QJsonArray toJson();
    Q_INVOKABLE void addCondition(QJsonArray json);
    Q_INVOKABLE void addCondition(QString qmlId, QJsonArray json);

    inline QString opFriendToRegovar(QString op) { return mOperatorMap.key(op); }
    inline QString opRegovarToFriend(QString op) { return mOperatorMap.value(op); }
    inline QString opIndexToRegovar(int op) { return mOperatorMap.key(mOpList.at(op)); }
    inline int opRegovarToIndex(QString op) { return mOpList.indexOf(mOperatorMap.value(op)); }

Q_SIGNALS:
    void qmlIdChanged();
    void filterChanged();
    void enabledChanged();
    void collapsedChanged();

private:
    QString mQmlId;
    ConditionType mType;
    QString mLeftOp;
    QString mRightOp;
    QString mOp;
    int mOpIndex;
    bool mEnabled;
    bool mCollapsed;
    QList<QObject*> mSubConditions;
    QStringList mOpList;
    QStringList mEnumList;
    QVariant mFieldValue;

    QJsonArray mJsonFilter;
    Annotation* mField;
    FilteringAnalysis* mAnalysis;


    static QStringList mNumberOp;
    static QStringList mStringOp;
    static QStringList mSetOp;
    static QStringList mEnumOp;
    static QStringList mLogicalOp;
    static QHash<QString, QString> mOperatorMap;
    static QHash<QString, QString> initOperatorMap();

};

#endif // CONDITIONBLOCK_H
