#ifndef RESOURCEMODEL_H
#define RESOURCEMODEL_H

#include <QObject>

class ResourceModel : public QObject
{
    Q_OBJECT
public:
    ResourceModel();
    ResourceModel(quint32 id);

    // Properties
    // Read
    quint32 id() const;
    // Write
    void setId(quint32 id);


    // Methods
    // Check if the user model is valid or not
    bool isValid() const;
    // Load resources
    virtual bool fromJson(QJsonDocument json) = 0;
    // Reset all values of the resources
    virtual void clear() = 0;

Q_SIGNALS:
    void resourceChanged();

public Q_SLOTS:


protected:
    quint32 mId = -1;
};

#endif // RESOURCEMODEL_H
