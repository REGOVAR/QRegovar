#ifndef ADVANCEDFILTERMODEL_H
#define ADVANCEDFILTERMODEL_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>

#include "set.h"
#include "Model/analysis/filtering/annotation.h"
#include "Model/analysis/filtering/advancedfilters/set.h"
#include "Model/regovar.h"

class Set;
class FilteringAnalysis;

class AdvancedFilterModel : public QObject
{
    Q_OBJECT

    // Generic
    Q_PROPERTY(QString qmlId READ qmlId)
    Q_PROPERTY(FilteringAnalysis* analysis READ analysis)
    Q_PROPERTY(ConditionType type READ type WRITE setType NOTIFY filterChanged)
    Q_PROPERTY(QString op READ op WRITE setOp NOTIFY filterChanged)
    // Logical block specific
    Q_PROPERTY(QList<QObject*> subConditions READ subConditions NOTIFY filterChanged)
    // Field block specific
    Q_PROPERTY(Annotation* field READ field WRITE setField NOTIFY filterChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY filterChanged)
    // Set block specific
    Q_PROPERTY(Set* set READ set WRITE setSet NOTIFY filterChanged)
    // UI
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool collapsed READ collapsed WRITE setCollapsed NOTIFY collapsedChanged)
    Q_PROPERTY(QStringList opList READ opList NOTIFY filterChanged)

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
    inline FilteringAnalysis* analysis() const { return mAnalysis; }
    inline ConditionType type() const { return mType; }
    inline QString op() const { return mOp; }
    inline QList<QObject*> subConditions() const { return mSubConditions; }
    inline Annotation* field() const { return mField; }
    inline QVariant value() const { return mFieldValue; }
    inline Set* set() const { return mSet; }
    inline bool enabled() const { return mEnabled; }
    inline bool collapsed() const { return mCollapsed; }
    inline QStringList opList() const { return mOpList; }

    // Setters
    inline virtual void setType(ConditionType type) { mType = type; updateOpList(); emit filterChanged(); }
    inline virtual void setOp(QString op) { mOp = op; emit filterChanged(); }
    inline virtual void setField(Annotation* field) { mField = field; updateOpList(); emit filterChanged(); }
    inline virtual void setValue(QVariant value) { mFieldValue = value; emit filterChanged(); }
    inline virtual void setSet(Set* set) { mSet = set; emit filterChanged(); }
    inline virtual void setEnabled(bool flag) { mEnabled = flag; emit enabledChanged(); }
    inline virtual void setCollapsed(bool flag) { mCollapsed = flag; emit collapsedChanged(); }


    // Methods
    Q_INVOKABLE virtual void clear();
    Q_INVOKABLE virtual void loadJson(QJsonArray filterJson);
    Q_INVOKABLE virtual QJsonArray toJson();
    Q_INVOKABLE void addCondition(QJsonArray json);
    Q_INVOKABLE void addCondition(QString qmlId, QJsonArray json);
    Q_INVOKABLE void removeCondition();
    Q_INVOKABLE void removeCondition(QString qmlId);
    Q_INVOKABLE inline QString opRegovarToFriend(QString op) { return mOperatorMap.key(op); }
    Q_INVOKABLE inline QString opFriendToRegovar(QString op) { return mOperatorMap.value(op); }
    void updateOpList();

Q_SIGNALS:
    void filterChanged();
    void enabledChanged();
    void collapsedChanged();

protected:
    QString mQmlId;
    FilteringAnalysis* mAnalysis = nullptr;
    ConditionType mType;
    QString mOp;
    Annotation* mField = nullptr;
    QVariant mFieldValue;
    Set* mSet;
    bool mEnabled = false;
    bool mCollapsed = true;
    QList<QObject*> mSubConditions;
    QStringList mOpList;

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



    // Field block
    Q_PROPERTY(QString fieldType READ fieldType NOTIFY filterChanged)
    Q_PROPERTY(QStringList fieldValueList READ fieldValueList NOTIFY filterChanged)




public:
    // Constructor
    explicit NewAdvancedFilterModel(QObject* parent=nullptr);
    explicit NewAdvancedFilterModel(FilteringAnalysis* parent);
    explicit NewAdvancedFilterModel(QJsonArray filterJson, FilteringAnalysis* parent);

    // Getters
    inline QString fieldType() const { return (mField != nullptr) ? mField->type() : ""; }
    inline QStringList fieldValueList() const { return mValueList; }

    // Methods
    Q_INVOKABLE inline void emitResetWizard() { emit resetWizard(); }
    Q_INVOKABLE void clear() override;
//    int opRegovarToIndex(QString op);
//    QString opIndexToRegovar(int op);


Q_SIGNALS:
    void filterChanged();
    void resetWizard();

protected:
    QStringList mValueList;


};

#endif // ADVANCEDFILTERMODEL_H
