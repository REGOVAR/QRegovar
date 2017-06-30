#ifndef SHOWCASE_H
#define SHOWCASE_H

#include <QObject>

class ShowCase : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int hour READ hour)
public:
    explicit ShowCase(QObject *parent = 0);

    int hour();


};

#endif // SHOWCASE_H
