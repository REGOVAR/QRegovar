#ifndef ANNOTATIONMODEL_H
#define ANNOTATIONMODEL_H

#include <QtCore>



/*!
 * \brief Wrapper for annotation data.
 */
class AnnotationModel : public QObject
{
    Q_OBJECT

    // Readonly annotation's informations
    Q_PROPERTY(QString uid READ uid)
    Q_PROPERTY(QString dbUid READ dbUid)
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(QString description READ description)
    Q_PROPERTY(QString type READ type)
    Q_PROPERTY(QString meta READ meta)
    Q_PROPERTY(QString version READ version)
    Q_PROPERTY(int order READ order)

public:


    explicit AnnotationModel(QObject *parent = 0);
    explicit AnnotationModel(QString uid, QString dbUid, QString name, QString description,
                             QString type, QString meta, QString version, int order=-1);
    AnnotationModel(const AnnotationModel &other);
    ~AnnotationModel();

    // Getters
    inline QString uid() { return mUid; }
    inline QString dbUid() { return mDbUid; }
    inline QString name() { return mName; }
    inline QString description() { return mDescription; }
    inline QString type() { return mType; }
    inline QString meta() { return mMeta; }
    inline QString version() { return mVersion; }
    inline int order() { return mOrder; }

    // Setters
    inline void setOrder(int order) { if (order >= 0) mOrder = order; }


private:
    QString mUid;
    QString mDbUid;
    QString mName;
    QString mDescription;
    QString mType;
    QString mMeta;
    QString mVersion;
    int mOrder;
};

#endif // ANNOTATIONMODEL_H
