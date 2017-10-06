#ifndef ADVANCEDFILTERMODEL_H
#define ADVANCEDFILTERMODEL_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>

#include "Model/analysis/filtering/annotation.h"
#include "Model/regovar.h"



class AdvancedFilterModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString qmlId READ qmlId)
    Q_PROPERTY(ConditionType type READ type WRITE setType NOTIFY filterChanged)
    Q_PROPERTY(QString leftOp READ leftOp WRITE setLeftOp NOTIFY filterChanged)
    Q_PROPERTY(QVariant rightOp READ rightOp WRITE setRightOp NOTIFY filterChanged)
    Q_PROPERTY(QString op READ op WRITE setOp NOTIFY filterChanged)
    Q_PROPERTY(QList<QObject*> subConditions READ subConditions NOTIFY filterChanged)
    Q_PROPERTY(QStringList opLogicalList READ opLogicalList NOTIFY filterChanged)

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool collapsed READ collapsed WRITE setCollapsed NOTIFY collapsedChanged)
    Q_PROPERTY(bool forceRefresh READ forceRefresh WRITE setForceRefresh NOTIFY forceRefreshChanged)



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
    inline QVariant rightOp() const { return mRightOp; }
    inline QString op() const { return mOp; }
    inline QList<QObject*> subConditions() const { return mSubConditions; }
    inline QStringList opLogicalList() const { return mOpLogicalList; }

    inline bool enabled() const { return mEnabled; }
    inline bool collapsed() const { return mCollapsed; }
    inline bool forceRefresh() const { return mForceRefresh; }

    // Setters
    inline void setType(ConditionType type) { mType = type; emit filterChanged(); }
    inline void setLeftOp(QString op) { mLeftOp = op; emit filterChanged(); }
    inline void setRightOp(QVariant op) { mRightOp = op; emit filterChanged(); }
    inline void setOp(QString op) { mOp = op; emit filterChanged(); }
    inline void setEnabled(bool flag) { mEnabled = flag; emit enabledChanged(); }
    inline void setCollapsed(bool flag) { mCollapsed = flag; emit collapsedChanged(); }
    inline void setForceRefresh(bool flag) { mForceRefresh = flag; emit forceRefreshChanged(); }


    // Methods
    virtual void setField(QString fieldUid);
    Q_INVOKABLE virtual void loadJson(QJsonArray filterJson);
    Q_INVOKABLE virtual QJsonArray toJson();
    Q_INVOKABLE void addCondition(QJsonArray json);
    Q_INVOKABLE void addCondition(QString qmlId, QJsonArray json);
    Q_INVOKABLE void removeCondition();
    Q_INVOKABLE void removeCondition(QString qmlId);
    Q_INVOKABLE inline QString opRegovarToFriend(QString op) { return mOperatorMap.value(op); }


Q_SIGNALS:
    void filterChanged();
    void enabledChanged();
    void collapsedChanged();
    void forceRefreshChanged();

protected:
    QString mQmlId;
    ConditionType mType;
    QString mLeftOp;
    QVariant mRightOp;
    QString mOp;
    bool mEnabled;
    bool mCollapsed;
    bool mForceRefresh;
    QList<QObject*> mSubConditions;

    Annotation* mField;
    FilteringAnalysis* mAnalysis;


    static QStringList mOpNumberList;
    static QStringList mOpStringList;
    static QStringList mOpSetList;
    static QStringList mOpEnumList;
    static QStringList mOpLogicalList;
    static QHash<QString, QString> mOperatorMap;
    static QHash<QString, QString> initOperatorMap();
};




//! Model used by the Creation/Edition form
class NewAdvancedFilterModel: public AdvancedFilterModel
{
    Q_OBJECT

    // Logical block
    Q_PROPERTY(int opLogicalIndex READ opLogicalIndex WRITE setOpLogicalIndex NOTIFY filterChanged)

    // Field block
    Q_PROPERTY(QString fieldType READ fieldType NOTIFY filterChanged)
    Q_PROPERTY(QStringList opFieldList READ opFieldList NOTIFY filterChanged)
    Q_PROPERTY(int opFieldIndex READ opFieldIndex WRITE setOpFieldIndex NOTIFY filterChanged)
    Q_PROPERTY(QVariant fieldValue READ fieldValue WRITE setFieldValue NOTIFY filterChanged)
    Q_PROPERTY(QStringList fieldValueList READ fieldValueList NOTIFY filterChanged)
    Q_PROPERTY(int valueIndex READ valueIndex WRITE setValueIndex NOTIFY filterChanged)

    // Set block
//    Q_PROPERTY(QString setTest READ setTest WRITE setSetTest NOTIFY setTestChanged)
//    Q_PROPERTY(QStringList opSetList READ opSetList NOTIFY filterChanged)
//    Q_PROPERTY(QStringList enumList READ enumList NOTIFY filterChanged)


public:
    // Constructor
    explicit NewAdvancedFilterModel(QObject* parent=nullptr);
    explicit NewAdvancedFilterModel(FilteringAnalysis* parent);
    explicit NewAdvancedFilterModel(QJsonArray filterJson, FilteringAnalysis* parent);

    // Getters
    inline int opLogicalIndex() const { return mOpLogicalIndex; }
    inline QString fieldType() const { return (mField != nullptr) ? mField->type() : ""; }
    inline QStringList opFieldList() const { return mOpFieldList; }
    inline int opFieldIndex() const { return mOpFieldIndex; }
    inline QVariant fieldValue() const { return mFieldValue; }
    inline QStringList fieldValueList() const { return mValueList; }
    inline int valueIndex() const { return mValueIndex; }


    // Setters
    inline void setOpLogicalIndex(int opIdx) { mOpLogicalIndex = opIdx; emit filterChanged(); }
    inline void setOpFieldIndex(int opIdx) { mOpFieldIndex = opIdx; emit filterChanged(); }
    inline void setFieldValue(QVariant val) { mFieldValue = val; emit filterChanged(); }
    inline void setValueIndex(int opIdx) { mValueIndex = opIdx; emit filterChanged(); }

    // Methods
    Q_INVOKABLE void clear();
    Q_INVOKABLE void setField(QString fieldUid) override;
    Q_INVOKABLE void loadJson(QJsonArray filterJson) override;
    Q_INVOKABLE QJsonArray toJson() override;
    inline QString opFriendToRegovar(QString op) { return mOperatorMap.key(op); }
    int opRegovarToIndex(QString op);
    QString opIndexToRegovar(int op);

Q_SIGNALS:
    void filterChanged();

protected:
    QStringList mOpFieldList;
    QStringList mValueList;
    int mOpLogicalIndex;
    int mOpFieldIndex;
    int mValueIndex;
    QVariant mFieldValue;


};

#endif // ADVANCEDFILTERMODEL_H
