#ifndef SUBJECT_H
#define SUBJECT_H

#include <QtCore>

class Subject : public QObject
{
    Q_OBJECT
public:
    explicit Subject(QObject *parent = nullptr);

signals:

public slots:
};

#endif // SUBJECT_H
