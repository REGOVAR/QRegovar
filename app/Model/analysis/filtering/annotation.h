#ifndef ANNOTATION_H
#define ANNOTATION_H

#include <QtCore>





/*!
 * \brief Wrapper for annotation fields data.
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
    explicit Annotation(QObject* parent = nullptr);
    explicit Annotation(QObject* parent, QString uid, QString dbUid, QString name, QString description,
                             QString type, QJsonObject meta, QString version, int order=-1);
//    Annotation(const Annotation &other);
//    ~Annotation();

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
    QString mUid;
    QString mDbUid;
    QString mName;
    QString mDescription;
    QString mType;
    QJsonObject mMeta;
    QString mVersion;
    int mOrder=-1;
};








class AnnotationDB : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid)
    Q_PROPERTY(QString name READ name NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(QString version READ version NOTIFY dataChanged)
    Q_PROPERTY(bool isDefault READ isDefault NOTIFY dataChanged)
    Q_PROPERTY(bool selected READ selected WRITE setSelected NOTIFY selectedChanged)

public:
    AnnotationDB(QObject* parent=nullptr);
    AnnotationDB(QString name, QString description, QString version, bool isDefault, QJsonArray fields, QObject* parent=nullptr);

    // Getters
    inline QString uid() const { return mUid; }
    inline QString name() const { return mName; }
    inline QString description() const { return mDescription; }
    inline QString version() const { return mVersion; }
    inline QList<Annotation*> fields() const { return mFields; }
    inline bool isDefault() const { return mDefault; }
    inline bool selected() const { return mSelected; }

    // Setters
    Q_INVOKABLE void setSelected(bool flag) { mSelected = flag; emit selectedChanged(); }
    inline bool isMandatory() { return mName == "Variant" || mName == "Regovar"; }


Q_SIGNALS:
    void dataChanged();
    void selectedChanged();

private:
    QString mUid;
    QString mName;
    QString mVersion;
    QString mDescription;
    bool mDefault;
    bool mSelected;
    QList<Annotation*> mFields;
};




#endif // ANNOTATION_H
