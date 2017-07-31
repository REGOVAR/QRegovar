#ifndef ANALYSIS_H
#define ANALYSIS_H

#include <QObject>

class Analysis : public QObject
{
    Q_OBJECT
public:
    explicit Analysis(QObject *parent = nullptr);

signals:

public slots:


protected:
    int mId;
    QString mName;
    QString mType;

};

#endif // ANALYSIS_H
