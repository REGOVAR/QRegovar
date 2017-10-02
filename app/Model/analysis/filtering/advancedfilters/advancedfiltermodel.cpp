#include "advancedfiltermodel.h"
#include <QUuid>

// init static lists
QStringList AdvancedFilterModel::mNumberOp = QStringList() << QString("<") << QString("≤") << QString("=") << QString("≥") << QString(">") << QString("≠");
QStringList AdvancedFilterModel::mStringOp = QStringList() << QString("=") << QString("≠") << QString(tr("Contains")) << QString(tr("Not contains"));
QStringList AdvancedFilterModel::mSetOp    = QStringList() << QString(tr("In")) << QString(tr("Not in"));
QStringList AdvancedFilterModel::mEnumOp   = QStringList() << QString("=") << QString("≠");
QStringList AdvancedFilterModel::mLogicalOp= QStringList() << QString("AND") << QString("OR");

QHash<QString, QString> AdvancedFilterModel::mOperatorMap = AdvancedFilterModel::initOperatorMap();

QHash<QString, QString> AdvancedFilterModel::initOperatorMap()
{
    // Mapping between "Regovar engine operators" and "friendly user operators"
    QHash<QString, QString> map;
    map.insert("<",  "<");
    map.insert("<=", "≤");
    map.insert(">",  ">");
    map.insert(">=", "≥");
    map.insert("==", "=");
    map.insert("!=", "≠");
    map.insert("IN", "∈");
    map.insert("NOTIN", "∉");
    map.insert("~", tr("Contains"));
    map.insert("!~", tr("Not contains"));
    map.insert("AND", tr("AND"));
    map.insert("OR", tr("OR"));

    return map;
}





// Constructors
AdvancedFilterModel::AdvancedFilterModel(QObject* parent): QObject(parent) {}
AdvancedFilterModel::AdvancedFilterModel(FilteringAnalysis* parent) : QObject(parent)
{
    mEnabled = true;
    mCollapsed = false;
    mType = LogicalBlock;
    mFieldValue = "";
    mQmlId = QUuid::createUuid().toString();
    mAnalysis = parent;

}

AdvancedFilterModel::AdvancedFilterModel(QJsonArray filterJson, FilteringAnalysis* parent) : QObject(parent)
{
    mEnabled = true;
    mCollapsed = false;
    mType = LogicalBlock;
    mFieldValue = "";
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

void AdvancedFilterModel::loadJson(QJsonArray filterJson)
{
    mJsonFilter = filterJson;
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

        setFieldUid(fieldJson[1].toString());
        if (mField->type() == "int")
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


QJsonArray AdvancedFilterModel::toJson()
{
    QJsonArray result;
    if (mType == LogicalBlock)
    {
        result.append(opIndexToRegovar(mOpIndex));
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

        qDebug() << "index " << mOpIndex << "list.count" << mOpList.count();
        qDebug() << "Trying mOpList.at(mOpIndex)";
        QString op = mOpList.at(mOpIndex);
        qDebug() << "result" << op;
        qDebug() << "Getting regovar op";
        QString opR = mOperatorMap.key(op);
        qDebug() << "result" << opR;

        result.append(opR);
        result.append(field);
        result.append(value);
    }


    return result;
}











void AdvancedFilterModel::setType(ConditionType type)
{
    mType = type;
    if (type == LogicalBlock)
    {
        mOpList.clear();
        mOpList.append(mLogicalOp);
        mOpIndex = opRegovarToIndex(mOp);
    }
    else if (type == SetBlock)
    {
        mOpList.clear();
        mOpList.append(mSetOp);
        mOpIndex = opRegovarToIndex(mOp);
    }
    // else : for field, nothing to do. Init is done when settings the field uid.

    emit filterChanged();
}

void AdvancedFilterModel::setFieldUid(QString fieldUid)
{
    FieldColumnInfos* info =  mAnalysis->getColumnInfo(fieldUid);
    if (info != nullptr)
    {
        mField = info->annotation();
        mLeftOp = mField->name();

        if (mField->type() == "int" || mField->type() == "float")
        {
            mOpList.clear();
            mOpList.append(mNumberOp);
            mOpIndex = opRegovarToIndex(mOp);
        }
        else if (mField->type() == "string" || mField->type() == "sequence")
        {
            mOpList.clear();
            mOpList.append(mStringOp);
            mOpIndex = opRegovarToIndex(mOp);
        }
        else if (mField->type() == "enum")
        {
            mOpList.clear();
            mOpList.append(mEnumOp);
            mOpIndex = opRegovarToIndex(mOp);
            mEnumList.clear();
            // TODO : load available values from mField->meta()
        }
        else if (mField->type() == "bool")
        {
            mOpList.clear();
            mOpList.append(mEnumOp);
            mOpIndex = opRegovarToIndex(mOp);
        }
        else if (mField->type() == "list")
        {
            mOpList.clear();
            mOpList.append(mSetOp);
            mOpIndex = opRegovarToIndex(mOp);
        }
    }
    else
    {
        qDebug() << "ERROR : unknow field id";
    }
    emit filterChanged();
}


