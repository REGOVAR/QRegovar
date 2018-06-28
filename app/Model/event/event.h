#ifndef EVENT_H
#define EVENT_H

#include <QtCore>
#include "Model/framework/regovarresource.h"
#include "Model/user/user.h"
#include "Model/analysis/analysis.h"
#include "Model/file/file.h"
#include "Model/panel/panel.h"
#include "Model/project/project.h"
#include "Model/subject/sample.h"
#include "Model/subject/subject.h"

class Event : public RegovarResource
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString message READ message NOTIFY dataChanged)
    Q_PROPERTY(QString details READ details NOTIFY dataChanged)
    Q_PROPERTY(User* author READ author NOTIFY dataChanged)
    Q_PROPERTY(QDateTime date READ date NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)
    // OPtional relations
    Q_PROPERTY(User* user READ user NOTIFY dataChanged)
    Q_PROPERTY(Project* project READ project NOTIFY dataChanged)
    //Q_PROPERTY(Pipeline* project READ project NOTIFY dataChanged)
    Q_PROPERTY(Analysis* analysis READ analysis NOTIFY dataChanged)
    Q_PROPERTY(Panel* panel READ panel NOTIFY dataChanged)
    Q_PROPERTY(Subject* subject READ subject NOTIFY dataChanged)
    Q_PROPERTY(Sample* sample READ sample NOTIFY dataChanged)
    Q_PROPERTY(File* file READ file NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject messageUI READ messageUI NOTIFY dataChanged)


public:
    // Constructor
    Event(QObject* parent=nullptr);
    Event(int id, QObject* parent=nullptr);
    Event(QJsonObject json, QObject* parent=nullptr);

    // Getters
    inline int id() const { return mId; }
    inline QString message() const { return mMessage; }
    inline QString details() const { return mDetails; }
    inline User* author() const { return mAuthor; }
    inline QDateTime date() const { return mDate; }
    inline QString type() const { return mType; }
    inline User* user() const { return mUser; }
    inline Project* project() const { return mProject; }
    inline Analysis* analysis() const { return mAnalysis; }
    inline Panel* panel() const { return mPanel; }
    inline Subject* subject() const { return mSubject; }
    inline Sample* sample() const { return mSample; }
    inline File* file() const { return mFile; }
    inline QJsonObject messageUI() const { return mMessageUI; }
    inline QString searchField() const { return mSearchField; }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(const QJsonObject& json, bool full_init=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Save event information onto server
    Q_INVOKABLE void save() override;
    //! Load event information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;



public Q_SLOTS:
    void updateSearchField() override;

private:
    int mId=-1;
    QString mMessage;
    QString mDetails;
    QDateTime mDate;
    QString mType;
    User* mAuthor = nullptr;
    User* mUser = nullptr;
    Project* mProject = nullptr;
    Analysis* mAnalysis = nullptr;
    Panel* mPanel = nullptr;
    Subject* mSubject = nullptr;
    Sample* mSample = nullptr;
    File* mFile = nullptr;
    QJsonObject mMessageUI;

    static QHash<QString, QString> mTypeIconMap;
    static QHash<QString, QString> initTypeIconMap();

};

#endif // EVENT_H
