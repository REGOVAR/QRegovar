#ifndef PANELENTRY_H
#define PANELENTRY_H

#include <QtCore>
#include "Model/framework/regovarresource.h"

class PanelEntry: public RegovarResource
{
    Q_OBJECT
    Q_PROPERTY(QString label READ label NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)
    Q_PROPERTY(QString details READ details NOTIFY dataChanged)


public:
    // Constructor
    PanelEntry(QObject* parent=nullptr);
    PanelEntry(QJsonObject json, QObject* parent=nullptr);

    // Getters
    inline QString label() const { return mLabel; }
    inline QString type() const { return mType; }
    inline QString details() const { return mDetails; }

    // Override ressource methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;


private:
    QString mLabel;
    QString mType;
    QString mDetails;
    QJsonObject mData;
};

#endif // PANELENTRY_H
