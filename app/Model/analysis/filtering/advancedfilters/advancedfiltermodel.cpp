#include "advancedfiltermodel.h"
#include <QUuid>

// init static lists
QStringList AdvancedFilterModel::mOpNumberList  = QStringList() << QString("<")   << QString("<=") << QString("==") << QString(">=") << QString(">") << QString("!=");
QStringList AdvancedFilterModel::mOpStringList  = QStringList() << QString("==")  << QString("!=") << QString("~") << QString("!~");
QStringList AdvancedFilterModel::mOpSetList     = QStringList() << QString("IN")  << QString("NOTIN");
QStringList AdvancedFilterModel::mOpEnumList    = QStringList() << QString("==")  << QString("!=");
QStringList AdvancedFilterModel::mOpLogicalList = QStringList() << QString("AND") << QString("OR");
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
    map.insert(tr("contains"), "~");
    map.insert(tr("not contains"), "!~");
    map.insert(tr("And"), "AND");
    map.insert(tr("Or"), "OR");

    return map;
}





// Constructors
AdvancedFilterModel::AdvancedFilterModel(QObject* parent): QObject(parent) {}
AdvancedFilterModel::AdvancedFilterModel(FilteringAnalysis* parent) : QObject(parent)
{
    clear();
    mQmlId = QUuid::createUuid().toString();
    mAnalysis = parent;
}

AdvancedFilterModel::AdvancedFilterModel(QJsonArray filterJson, FilteringAnalysis* parent) : QObject(parent)
{
    clear();
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



void AdvancedFilterModel::clear()
{
    mSubConditions.clear();
    mOpList = mOpLogicalList;
    mField = nullptr;
    mSet = nullptr;
    mEnabled = true;
    mCollapsed = false;
    mType = LogicalBlock;
    mOp = mOpLogicalList[0];
}

void AdvancedFilterModel::loadJson(QJsonArray filterJson)
{
    clear();
    setOp(filterJson[0].toString());
    if (mOpLogicalList.indexOf(mOp) != -1)
    {
        setType(LogicalBlock);
        mOpList = mOpLogicalList;

        QJsonArray sub = filterJson[1].toArray();
        for (int idx=0; idx<sub.count(); idx++)
        {
            addCondition(sub[idx].toArray());
        }
    }
    else if (mOpSetList.indexOf(mOp) != -1)
    {
        setType(SetBlock);
        mOpList = mOpSetList;

        QJsonArray set = filterJson[1].toArray();
        mSet = mAnalysis->getSetById(set[0].toString(), set[1].toString());
    }
    else
    {
        setType(FieldBlock);

        // Get field.
        QJsonArray fieldJson = filterJson[1].toArray();
        QJsonArray valueJson = filterJson[2].toArray();
        if (fieldJson[0].toString() != "field")
        {
            qDebug() << "ERROR : Json filter not well formated. Unable to load filter";
            return;
        }

        // Set field
        FieldColumnInfos* info =  mAnalysis->getColumnInfo(fieldJson[1].toString());
        if (info != nullptr)
        {
            mField = info->annotation();
        }

        if (mField != nullptr)
        {
            if (mField->type() == "int" || mField->type() == "sample_array")
            {
                mFieldValue = QVariant(valueJson[1].toInt());
                mOpList = mOpNumberList;
            }
            else if (mField->type() == "string" || mField->type() == "sequence")
            {
                mFieldValue = QVariant(valueJson[1].toString());
                mOpList = mOpStringList;
            }
            else if (mField->type() == "float")
            {
                mFieldValue = QVariant(valueJson[1].toDouble());
                mOpList = mOpNumberList;
            }
            else if (mField->type() == "enum")
            {
                mFieldValue = QVariant(valueJson[1].toDouble());
                mOpList = mOpEnumList;
            }
            else if (mField->type() == "bool")
            {
                mFieldValue = QVariant(valueJson[1].toBool());
            }
            else if (mField->type() == "list")
            {
                // TODO: not well managed
                qDebug() << "WARNING : This kind of field is not well managed...";
                mFieldValue = QVariant(valueJson[1].toString());
                mOpList = mOpStringList;
            }
        }
        else
        {
            qDebug() << "ERROR : Unknow field type, not able to create filter field condition";
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
        value.append(QJsonValue::fromVariant(mFieldValue));

        result.append(field);
        result.append(value);
    }
    else if (mType == SetBlock)
    {
        result.append(mSet->toJson());
    }


    return result;
}








//bool AdvancedFilterModel::setField(QString fieldUid)
//{
//    FieldColumnInfos* info =  mAnalysis->getColumnInfo(fieldUid);
//    if (info != nullptr)
//    {
//        mField = info->annotation();
//        mLeftOp = mField->name();
//    }
//    else
//    {
//        qDebug() << "ERROR : unknow field id";
//        return false;
//    }
//    emit filterChanged();
//    return true;
//}

void AdvancedFilterModel::updateOpList()
{
    mOpList.clear();
    if (mType == LogicalBlock)
    {
        mOpList = mOpLogicalList;
    }
    else if (mType == FieldBlock)
    {
        if (mField == nullptr)
        {
            return;
        }
        if (mField->type() == "int" || mField->type() == "sample_array")
        {
            mOpList = mOpNumberList;
        }
        else if (mField->type() == "string" || mField->type() == "sequence")
        {
            mOpList = mOpStringList;
        }
        else if (mField->type() == "float")
        {
            mOpList = mOpNumberList;
        }
        else if (mField->type() == "enum")
        {
            mOpList = mOpEnumList;
        }
        else if (mField->type() == "bool")
        {
        }
        else if (mField->type() == "list")
        {
            // TODO: not well managed
            qDebug() << "WARNING : This kind of field is not well managed...";
            mOpList = mOpStringList;
        }
    }
    else if (mType == SetBlock)
    {
        mOpList = mOpSetList;
    }
}





// =============================================================================================================
// NewAdvancedFilterModel
// =============================================================================================================







// Constructors
NewAdvancedFilterModel::NewAdvancedFilterModel(QObject* parent): AdvancedFilterModel(parent) {}
NewAdvancedFilterModel::NewAdvancedFilterModel(FilteringAnalysis* parent) : AdvancedFilterModel(parent) {}
NewAdvancedFilterModel::NewAdvancedFilterModel(QJsonArray filterJson, FilteringAnalysis* parent) :  AdvancedFilterModel(filterJson, parent) {}




void NewAdvancedFilterModel::clear()
{
    // inherited from AdvancedFilterModel
    mSubConditions.clear();
    mOpList = mOpLogicalList;
    mField = nullptr;
    mSet = nullptr;
    mEnabled = true;
    mCollapsed = false;
    mType = LogicalBlock;
    mOp = mOpLogicalList[0];
    // Specific NewAdvancedFilterModel
    mValueList.clear();

    emit filterChanged();
}


