#ifndef REGOVARMODEL_H
#define REGOVARMODEL_H
#include <QAbstractListModel>

class RegovarModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum {
        TitleRole = Qt::UserRole +1,
        InvertRole
    };

    RegovarModel(QObject * parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;

    QHash<int, QByteArray> roleNames() const Q_DECL_OVERRIDE;
    Q_INVOKABLE void add();



private:
    QList<QString> mDatas;

};

#endif // REGOVARMODEL_H
