#include "samplesortfilterproxymodel.h"

SampleSortFilterProxyModel::SampleSortFilterProxyModel(QObject* parent):  QSortFilterProxyModel(parent)
{
    connect(this, &QSortFilterProxyModel::rowsInserted, this, &SampleSortFilterProxyModel::countChanged);
    connect(this, &QSortFilterProxyModel::rowsRemoved, this, &SampleSortFilterProxyModel::countChanged);
}



int SampleSortFilterProxyModel::count() const
{
    return rowCount();
}

QObject* SampleSortFilterProxyModel::source() const
{
    return sourceModel();
}

void SampleSortFilterProxyModel::setSource(QObject *source)
{
    setSourceModel(qobject_cast<QAbstractItemModel *>(source));
}

QByteArray SampleSortFilterProxyModel::sortRole() const
{
    return m_sortRole;
}

void SampleSortFilterProxyModel::setSortRole(const QByteArray &role)
{
    if (m_sortRole != role) {
        m_sortRole = role;
        if (m_complete)
            QSortFilterProxyModel::setSortRole(roleKey(role));
    }
}

void SampleSortFilterProxyModel::setSortOrder(Qt::SortOrder order)
{
    QSortFilterProxyModel::sort(0, order);
}

QByteArray SampleSortFilterProxyModel::filterRole() const
{
    return m_filterRole;
}

void SampleSortFilterProxyModel::setFilterRole(const QByteArray &role)
{
    if (m_filterRole != role) {
        m_filterRole = role;
        if (m_complete)
            QSortFilterProxyModel::setFilterRole(roleKey(role));
    }
}

QString SampleSortFilterProxyModel::filterString() const
{
    return filterRegExp().pattern();
}

void SampleSortFilterProxyModel::setFilterString(const QString &filter)
{
    setFilterRegExp(QRegExp(filter, filterCaseSensitivity())); // , static_cast<QRegExp::PatternSyntax>(filterSyntax())
}



QJSValue SampleSortFilterProxyModel::get(int idx) const
{
    QJSEngine *engine = qmlEngine(this);
    QJSValue value = engine->newObject();
    if (idx >= 0 && idx < count()) {
        QHash<int, QByteArray> roles = roleNames();
        QHashIterator<int, QByteArray> it(roles);
        while (it.hasNext()) {
            it.next();
            value.setProperty(QString::fromUtf8(it.value()), data(index(idx, 0), it.key()).toString());
        }
    }
    return value;
}

void SampleSortFilterProxyModel::classBegin()
{
}

void SampleSortFilterProxyModel::componentComplete()
{
    m_complete = true;
    if (!m_sortRole.isEmpty())
        QSortFilterProxyModel::setSortRole(roleKey(m_sortRole));
    if (!m_filterRole.isEmpty())
        QSortFilterProxyModel::setFilterRole(roleKey(m_filterRole));
}

int SampleSortFilterProxyModel::roleKey(const QByteArray &role) const
{
    QHash<int, QByteArray> roles = roleNames();
    QHashIterator<int, QByteArray> it(roles);
    while (it.hasNext()) {
        it.next();
        if (it.value() == role)
            return it.key();
    }
    return -1;
}

QHash<int, QByteArray> SampleSortFilterProxyModel::roleNames() const
{
    if (QAbstractItemModel *source = sourceModel())
        return source->roleNames();
    return QHash<int, QByteArray>();
}

bool SampleSortFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    QRegExp rx = filterRegExp();
    if (rx.isEmpty())
        return true;
    QAbstractItemModel *model = sourceModel();
    if (filterRole().isEmpty()) {
        QHash<int, QByteArray> roles = roleNames();
        QHashIterator<int, QByteArray> it(roles);
        while (it.hasNext()) {
            it.next();
            QModelIndex sourceIndex = model->index(sourceRow, 0, sourceParent);
            QString key = model->data(sourceIndex, it.key()).toString();
            if (key.contains(rx))
                return true;
        }
        return false;
    }
    QModelIndex sourceIndex = model->index(sourceRow, 0, sourceParent);
    if (!sourceIndex.isValid())
        return true;
    QString key = model->data(sourceIndex, roleKey(filterRole())).toString();
    return key.contains(rx);
}
