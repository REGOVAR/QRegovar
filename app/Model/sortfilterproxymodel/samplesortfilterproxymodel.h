#ifndef SAMPLESORTFILTERPROXYMODEL_H
#define SAMPLESORTFILTERPROXYMODEL_H


#include <QtCore>
#include <QtQml>


class SampleSortFilterProxyModel: public QSortFilterProxyModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QObject* source READ source WRITE setSource)

    Q_PROPERTY(QByteArray sortRole READ sortRole WRITE setSortRole)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder)

    Q_PROPERTY(QByteArray filterRole READ filterRole WRITE setFilterRole)
    Q_PROPERTY(QString filterString READ filterString WRITE setFilterString)

public:
    explicit SampleSortFilterProxyModel(QObject* parent=nullptr);

    QObject* source() const;
    void setSource(QObject *source);

    QByteArray sortRole() const;
    void setSortRole(const QByteArray &role);

    void setSortOrder(Qt::SortOrder order);

    QByteArray filterRole() const;
    void setFilterRole(const QByteArray &role);

    QString filterString() const;
    void setFilterString(const QString &filter);


    int count() const;
    Q_INVOKABLE QJSValue get(int index) const;

    void classBegin();
    void componentComplete();


Q_SIGNALS:
    void countChanged();

private:
    int roleKey(const QByteArray &role) const;
    QHash<int, QByteArray> roleNames() const;
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;

    bool m_complete = false;
    QByteArray m_sortRole;
    QByteArray m_filterRole;
};

#endif // SAMPLESORTFILTERPROXYMODEL_H
