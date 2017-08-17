#ifndef ANNOTATION_H
#define ANNOTATION_H

#include <QtCore>



/*!
 * \brief Wrapper for annotation data.
 */
class Annotation : public QObject
{
    Q_OBJECT

    // Readonly annotation's informations
    Q_PROPERTY(QString uid READ uid)
    Q_PROPERTY(QString dbUid READ dbUid)
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(QString description READ description)
    Q_PROPERTY(QString type READ type)
    Q_PROPERTY(QJsonObject meta READ meta)
    Q_PROPERTY(QString version READ version)
    Q_PROPERTY(int order READ order)

public:


    explicit Annotation(QObject* parent = 0);
    explicit Annotation(QObject* parent, QString uid, QString dbUid, QString name, QString description,
                             QString type, QJsonObject meta, QString version, int order=-1);
    Annotation(const Annotation &other);
    ~Annotation();

    // Getters
    inline QString uid() { return mUid; }
    inline QString dbUid() { return mDbUid; }
    inline QString name() { return mName; }
    inline QString description() { return mDescription; }
    inline QString type() { return mType; }
    inline QJsonObject meta() { return mMeta; }
    inline QString version() { return mVersion; }
    inline int order() { return mOrder; }

    // Setters
    inline void setOrder(int order) { if (order >= 0) mOrder = order; }


private:
    QString mUid="";
    QString mDbUid="";
    QString mName="";
    QString mDescription="";
    QString mType="";
    QJsonObject mMeta;
    QString mVersion="";
    int mOrder=-1;
};

#endif // ANNOTATION_H
