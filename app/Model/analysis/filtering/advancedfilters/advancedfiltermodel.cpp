#include "advancedfiltermodel.h"
#include <QUuid>

// init static lists
QStringList AdvancedFilterModel::mOpNumberList  = QStringList() << QString("<") << QString("≤") << QString("=") << QString("≥") << QString(">") << QString("≠");
QStringList AdvancedFilterModel::mOpStringList  = QStringList() << QString("=") << QString("≠") << QString(tr("Contains")) << QString(tr("Not contains"));
QStringList AdvancedFilterModel::mOpSetList     = QStringList() << QString(tr("In")) << QString(tr("Not in"));
QStringList AdvancedFilterModel::mOpEnumList    = QStringList() << QString("=") << QString("≠");
QStringList AdvancedFilterModel::mOpLogicalList = QStringList() << tr("AND") << tr("OR");
QHash<QString, QString> AdvancedFilterModel::mOperatorMap = AdvancedFilterModel::initOperatorMap();
QHash<QString, QString> AdvancedFilterModel::initOperatorMap()
{
    // Mapping between "friendly user operators" and "Regovar engine operators"
    QHash<QString, QString> map;
    map.insert("<",  "<");
    map.insert("≤", "<=");
    map.insert(">",  ">");
    map.insert("≥", ">=");
    map.insert("=", "==");
    map.insert("≠", "!=");
    map.insert("∈", "IN");
    map.insert("∉", "NOTIN");
    map.insert(tr("Contains"), "~");
    map.insert(tr("Not contains"), "!~");
    map.insert("AND", tr("AND"));
    map.insert("OR", tr("OR"));

    return map;
}





// Constructors
AdvancedFilterModel::AdvancedFilterModel(QObject* parent): QObject(parent) {}
AdvancedFilterModel::AdvancedFilterModel(FilteringAnalysis* parent) : QObject(parent)
{
    mField = nullptr;
    mEnabled = true;
    mCollapsed = false;
    mType = LogicalBlock;
    mQmlId = QUuid::createUuid().toString();
    mAnalysis = parent;
}

AdvancedFilterModel::AdvancedFilterModel(QJsonArray filterJson, FilteringAnalysis* parent) : QObject(parent)
{
    mField = nullptr;
    mEnabled = true;
    mCollapsed = false;
    mType = LogicalBlock;
    mQmlId = QUuid::createUuid().toString();
    mAnalysis = parent;
    loadJson(filterJson);
}



// Methods

void AdvancedFilterModel::addCondition(QString qmlId, QJsonArray json)
{
    if (mQmlId == qmlId)
    {
        addCondition(json);
    }
    else
    {
        foreach (QObject* o, mSubConditions)
        {
            AdvancedFilterModel* cond = qobject_cast<AdvancedFilterModel*>(o);
            cond->addCondition(qmlId, json);
        }
    }
}
void AdvancedFilterModel::addCondition(QJsonArray json)
{
    mSubConditions.append(new AdvancedFilterModel(json, mAnalysis));
    emit filterChanged();
}

void AdvancedFilterModel::removeCondition()
{
    mAnalysis->advancedfilter()->removeCondition(mQmlId);
}
void AdvancedFilterModel::removeCondition(QString qmlId)
{
    foreach (QObject* o, mSubConditions)
    {
        AdvancedFilterModel* cond = qobject_cast<AdvancedFilterModel*>(o);
        if (cond->qmlId() == qmlId)
        {
            mSubConditions.removeOne(o);
            emit filterChanged();
            return;
        }
        cond->removeCondition(qmlId);
    }
}


void AdvancedFilterModel::loadJson(QJsonArray filterJson)
{
    mSubConditions.clear();
    setOp(filterJson[0].toString());
    if (mOp == "AND" || mOp == "OR")
    {
        setType(LogicalBlock);
        setRightOp(mOpLogicalList.indexOf(mOperatorMap[mOp]));

        QJsonArray sub = filterJson[1].toArray();
        for (int idx=0; idx<sub.count(); idx++)
        {
            addCondition(sub[idx].toArray());
        }
    }
    else if (mOp == "IN" || mOp == "NOTIN")
    {
        setType(SetBlock);
        setLeftOp(filterJson[1].toString());
        setRightOp(filterJson[2].toString());
    }
    else
    {
        setType(FieldBlock);

        // Get field. We assume that the field is alwais at the left operande
        QJsonArray fieldJson = filterJson[1].toArray();
        QJsonArray valueJson = filterJson[2].toArray();
        if (fieldJson[0].toString() != "field" || valueJson[0].toString() != "value")
        {
            qDebug() << "Json filter not well formated. Unable to load filter";
            return;
        }


        if (setField(fieldJson[1].toString()))
        {
            if (mField->type() == "int" || mField->type() == "sample_array")
            {
                mRightOp = QVariant(valueJson[1].toInt());
            }
            else if (mField->type() == "string" || mField->type() == "sequence")
            {
                mRightOp = QVariant(valueJson[1].toString());
            }
            else if (mField->type() == "float")
            {
                mRightOp = QVariant(valueJson[1].toDouble());
            }
            else if (mField->type() == "enum")
            {
                mRightOp = QVariant(valueJson[1].toDouble());
            }
            else if (mField->type() == "bool")
            {
                mRightOp = QVariant(valueJson[1].toBool());
            }
            else if (mField->type() == "list")
            {
                // TODO: not well managed
                mRightOp = QVariant(valueJson[1].toString());
            }
        }
        else
        {
            qDebug() << "ERROR field unknow, not able to create filter field condition";
        }
    }

    emit filterChanged();
}


QJsonArray AdvancedFilterModel::toJson()
{
    QJsonArray result;
    result.append(mOp);
    if (mType == LogicalBlock)
    {
        QJsonArray sub;
        foreach (QObject* o, mSubConditions)
        {
            AdvancedFilterModel* cond = qobject_cast<AdvancedFilterModel*>(o);
            sub.append(cond->toJson());
        }
        result.append(sub);
    }
    else if (mType == FieldBlock)
    {
        QJsonArray field;
        field.append("field");
        field.append(mField->uid());
        QJsonArray value;
        value.append("value");
        value.append(QJsonValue::fromVariant(mRightOp));

        result.append(field);
        result.append(value);
    }
    else if (mType == SetBlock)
    {
        QJsonArray field;
        field.append("field");
        field.append(mField->uid());
        QJsonArray value;
        value.append("value");
        value.append(QJsonValue::fromVariant(mRightOp));

        result.append(mLeftOp);
        result.append(value);
    }


    return result;
}








bool AdvancedFilterModel::setField(QString fieldUid)
{
    FieldColumnInfos* info =  mAnalysis->getColumnInfo(fieldUid);
    if (info != nullptr)
    {
        mField = info->annotation();
        mLeftOp = mField->name();
    }
    else
    {
        qDebug() << "ERROR : unknow field id";
        return false;
    }
    emit filterChanged();
    return true;
}






// =============================================================================================================
// NewAdvancedFilterModel
// =============================================================================================================







// Constructors
NewAdvancedFilterModel::NewAdvancedFilterModel(QObject* parent): AdvancedFilterModel(parent) {}
NewAdvancedFilterModel::NewAdvancedFilterModel(FilteringAnalysis* parent) : AdvancedFilterModel(parent) {}
NewAdvancedFilterModel::NewAdvancedFilterModel(QJsonArray filterJson, FilteringAnalysis* parent) :  AdvancedFilterModel(filterJson, parent) {}





void NewAdvancedFilterModel::loadJson(QJsonArray filterJson)
{
    setOp(filterJson[0].toString());
    if (mOp == "AND" || mOp == "OR")
    {
        setType(LogicalBlock);

        QJsonArray sub = filterJson[1].toArray();
        for (int idx=0; idx<sub.count(); idx++)
        {
            addCondition(sub[idx].toArray());
        }
    }
    else if (mOp == "IN" || mOp == "NOTIN")
    {
        setType(SetBlock);
        setLeftOp(filterJson[1].toString());
        setRightOp(filterJson[2].toString());
    }
    else
    {
        setType(FieldBlock);

        // Get field. We assume that the field is alwais at the left operande
        QJsonArray fieldJson = filterJson[1].toArray();
        QJsonArray valueJson = filterJson[2].toArray();
        if (fieldJson[0].toString() != "field" || valueJson[0].toString() != "value")
        {
            qDebug() << "Json filter not well formated. Unable to load filter";
            return;
        }

        setField(fieldJson[1].toString());
        if (mField->type() == "int" || mField->type() == "sample_array")
        {
            mFieldValue = QVariant(valueJson[1].toInt());
        }
        else if (mField->type() == "string" || mField->type() == "sequence")
        {
            mFieldValue = QVariant(valueJson[1].toString());
        }
        else if (mField->type() == "float")
        {
            mFieldValue = QVariant(valueJson[1].toDouble());
        }
        else if (mField->type() == "enum")
        {
            mFieldValue = QVariant(valueJson[1].toDouble());
        }
        else if (mField->type() == "bool")
        {
            mFieldValue = QVariant(valueJson[1].toBool());
        }
        else if (mField->type() == "list")
        {
            // TODO: not well managed
            mFieldValue = QVariant(valueJson[1].toString());
        }
    }

    emit filterChanged();
}


QJsonArray NewAdvancedFilterModel::toJson()
{
    QJsonArray result;
    if (mType == LogicalBlock)
    {
        result.append(opIndexToRegovar(mOpLogicalIndex));
        QJsonArray sub;
        foreach (QObject* o, mSubConditions)
        {
            AdvancedFilterModel* cond = qobject_cast<AdvancedFilterModel*>(o);
            sub.append(cond->toJson());
        }
        result.append(sub);
    }
    else if (mType == FieldBlock)
    {
        if (mField != nullptr)
        {
            QJsonArray field;
            field.append("field");
            field.append(mField->uid());
            QJsonArray value;
            value.append("value");
            value.append(QJsonValue::fromVariant(mFieldValue));

            if (mField->type() == "bool")
            {
                result.append("==");
            }
            else
            {
                result.append(opIndexToRegovar(mOpFieldIndex));
            }

            result.append(field);
            result.append(value);
        }
    }

    return result;
}




void NewAdvancedFilterModel::clear()
{
    mField = nullptr;
    mType = LogicalBlock;
    mOpLogicalIndex = 0;
    mOpFieldIndex = 0;
    mValueIndex = 0;

    emit filterChanged();
}

bool NewAdvancedFilterModel::setField(QString fieldUid)
{
    FieldColumnInfos* info =  mAnalysis->getColumnInfo(fieldUid);
    if (info != nullptr)
    {
        mField = info->annotation();
        mLeftOp = mField->name();

        if (mField->type() == "int" || mField->type() == "float" || mField->type() == "sample_array")
        {
            mOpFieldList.clear();
            mOpFieldList.append(mOpNumberList);
            mOpFieldIndex = opRegovarToIndex(mOp);
        }
        else if (mField->type() == "string" || mField->type() == "sequence")
        {
            mOpFieldList.clear();
            mOpFieldList.append(mOpStringList);
            mOpFieldIndex = opRegovarToIndex(mOp);
        }
        else if (mField->type() == "enum")
        {
            mOpFieldList.clear();
            mOpFieldList.append(mOpEnumList);
            mOpFieldIndex = opRegovarToIndex(mOp);
            // TODO : load available values from mField->meta()
            mValueList.clear();
        }
        else if (mField->type() == "bool")
        {
            mOpFieldList.clear();
            mOpFieldList.append(mOpEnumList);
            mOpFieldIndex = opRegovarToIndex(mOp);
        }
        else if (mField->type() == "list")
        {
            mOpFieldList.clear();
            mOpFieldList.append(mOpSetList);
            mOpFieldIndex = opRegovarToIndex(mOp);
        }
    }
    else
    {
        qDebug() << "ERROR : unknow field id";
        return false;
    }
    emit filterChanged();
    return true;
}

int NewAdvancedFilterModel::opRegovarToIndex(QString op)
{
    if (mOperatorMap.values().contains(op))
        op = mOperatorMap.key(op);
    else
        qDebug() << "WARNING : filter field operator not reconized :" << op;

    if (mType == LogicalBlock)
    {
        return mOpLogicalList.indexOf(op);
    }
    else
    {
        return mOpFieldList.indexOf(op);
    }
    return -1;
}

QString NewAdvancedFilterModel::opIndexToRegovar(int op)
{
    QString opS;
    if (mType == LogicalBlock)
    {
        if (op>=0 && op<mOpLogicalList.count())
        {
            opS = mOpLogicalList[op];
        }
    }
    else
    {
        if (op>=0 && op<mOpFieldList.count())
        {
            opS = mOpFieldList[op];
        }
    }

    if (mOperatorMap.contains(opS))  return mOperatorMap[opS];
    qDebug() << "WARNING : return unknow filter field operator :" << opS;
    return opS;
}
