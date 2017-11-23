#ifndef TOOLSMANAGER_H
#define TOOLSMANAGER_H

#include <QObject>

class ToolsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> exporters READ exporters NOTIFY neverChanged)
    Q_PROPERTY(QList<QObject*> reporters READ reporters NOTIFY neverChanged)
public:
    // Constructors
    explicit ToolsManager(QObject* parent = nullptr);

    // Getters
    inline QList<QObject*> exporters() const { return mExporters; }
    inline QList<QObject*> reporters() const { return mReporters; }


Q_SIGNALS:
    //! special signal used for QML property that never changed to avoid to declare to many useless signal
    //! QML need that property declare a "changed" event for binding
    void neverChanged();


private:
    //! list of export tool for variant selection
    QList<QObject*> mExporters;
    //! list of report tool for variant selection
    QList<QObject*> mReporters;
};

#endif // TOOLSMANAGER_H
