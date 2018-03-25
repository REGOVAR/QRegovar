#include "dynamicformmodel.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

DynamicFormModel::DynamicFormModel(Pipeline* pipeline) : QAbstractListModel(pipeline)
{
    mPipeline = pipeline;
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Order);
}


void DynamicFormModel::load(QUrl jsonUrl)
{
    if (!mLoaded && jsonUrl.isValid())
    {
        QString url = jsonUrl.path();
        Request* req = Request::download(url);
        connect(req, &Request::downloadReceived, [this, req](bool success, const QByteArray& data)
        {
            if (success)
            {
                QJsonDocument doc = QJsonDocument::fromJson(data);
                QJsonObject json = doc.object();
                load(json);
            }
            else
            {
                // TODO: create json error from scratch
                QJsonDocument doc = QJsonDocument::fromJson(data);
                QJsonObject jsonError = doc.object();
                jsonError.insert("method", Q_FUNC_INFO);
                regovar->raiseError(jsonError);
            }
            req->deleteLater();
        });
    }
}


void DynamicFormModel::load(QJsonObject json)
{
    if (!mLoaded && !json.isEmpty())
    {
        beginResetModel();
        mFieldList.clear();
        if (json.contains("properties"))
        {
            json = json["properties"].toObject();
        }
        int order = 0;
        for (const QString& fieldId: json.keys())
        {
            QJsonObject fieldData = json[fieldId].toObject();
            fieldData.insert("id", fieldId);
            DynamicFormFieldModel* field = new DynamicFormFieldModel(fieldData, order, this);
            mFieldList.append(field);
            ++order;
        }
        endResetModel();
        mLoaded = true;
        emit loadedChanged();
        emit countChanged();
    }
}


void DynamicFormModel::reset()
{
    if (mLoaded)
    {
        for (DynamicFormFieldModel* field: mFieldList)
        {
            field->reset();
        }
    }
}

bool DynamicFormModel::validate()
{
    if (!mLoaded) return false;

    bool isValid = true;
    for (DynamicFormFieldModel* field: mFieldList)
    {
        isValid = field->validate() && isValid;
    }
    return isValid;
}

QJsonObject DynamicFormModel::getResult()
{
    QJsonObject result;
    if (mLoaded)
    {
        for (const DynamicFormFieldModel* field: mFieldList)
        {
            if (field->value().isValid())
            {
                if (field->type() == "integer")
                {
                    result.insert(field->id(), field->value().toInt());
                }
                else if (field->type() == "number")
                {
                    result.insert(field->id(), field->value().toDouble());
                }
                else
                {
                    result.insert(field->id(), field->value().toJsonValue());
                }
            }
        }
    }
    return result;
}

DynamicFormFieldModel* DynamicFormModel::getAt(int position)
{

    if (position >=0 && position < rowCount())
    {
        return mFieldList[position];
    }
    return nullptr;
}





QString DynamicFormModel::printConfig()
{
    QString result;
    if (mLoaded)
    {
        for (const DynamicFormFieldModel* field: mFieldList)
        {
            if (field->value().isValid())
            {
                result += field->id() + ": " + field->value().toString() + "\n";
            }
        }
    }
    return result;
}


int DynamicFormModel::rowCount(const QModelIndex&) const
{
    return mFieldList.count();
}


QVariant DynamicFormModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mFieldList.count())
        return QVariant();

    const DynamicFormFieldModel* field= mFieldList[index.row()];
    if (role == Title || role == Qt::DisplayRole)
        return field->title();
    else if (role == Id)
        return field->id();
    else if (role == Type)
        return field->type();
    else if (role == Description)
        return field->description();
    else if (role == Order)
        return field->order();
    else if (role == EnumValues)
        return field->enumValues();
    else if (role == Required)
        return field->required();
    else if (role == Value)
        return field->value();
    else if (role == DefaultValue)
        return field->defaultValue();
    else if (role == SearchField)
        return field->searchField();
    return QVariant();
}



QHash<int, QByteArray> DynamicFormModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Type] = "type";
    roles[Title] = "title";
    roles[Description] = "description";
    roles[Order] = "order";
    roles[EnumValues] = "enumValues";
    roles[Required] = "required";
    roles[Value] = "value";
    roles[DefaultValue] = "defaultValue";
    roles[SearchField] = "searchField";
    return roles;
}
