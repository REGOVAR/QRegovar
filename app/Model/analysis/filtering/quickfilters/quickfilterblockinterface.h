#ifndef QUICKFILTERBLOCKINTERFACE_H
#define QUICKFILTERBLOCKINTERFACE_H

#include <QVariant>
#include <QObject>

class QuickFilterBlockInterface : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isVisible READ isVisible)

public:
    explicit QuickFilterBlockInterface(QObject *parent = nullptr);


    //! Indicates if this filter shall be displayed in the UI (by example some filter are only for "Trio analysis")
    Q_INVOKABLE virtual bool isVisible() = 0;
    //! Return the filter query as Json string that will be concatened with other quickFilters
    Q_INVOKABLE virtual QString getFilter() = 0;
    //! Generic method to set value of the filter thanks to the UI.
    Q_INVOKABLE virtual void setFilter(int id, QVariant value) = 0;
    //! Reset the filter
    Q_INVOKABLE virtual void clear() = 0;


};

#endif // QUICKFILTERBLOCKINTERFACE_H
