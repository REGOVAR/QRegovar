#ifndef REMOTELOGMODEL_H
#define REMOTELOGMODEL_H

#include <QtCore>
#include "Model/analysis/analysis.h"

class RemoteLogModel : public QObject
{
    Q_OBJECT
    // Log attributes
    Q_PROPERTY(bool autoRefresh READ autoRefresh WRITE setAutoRefresh NOTIFY dataChanged)
    Q_PROPERTY(int autoRefreshInterval READ autoRefreshInterval WRITE setAutoRefreshInterval NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    Q_PROPERTY(QString url READ url NOTIFY dataChanged)
    Q_PROPERTY(qint64 linesNumber READ linesNumber NOTIFY dataChanged)
    Q_PROPERTY(qint64 size READ size NOTIFY dataChanged)
    Q_PROPERTY(QString text READ text NOTIFY dataChanged)
    // Search/filter attributes
    Q_PROPERTY(QString searchPattern READ searchPattern WRITE setSearchPattern NOTIFY searchChanged)
    Q_PROPERTY(QList<int> searchResult READ searchResult NOTIFY searchChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)


public:
    // Constructor
    explicit RemoteLogModel(QObject* parent=nullptr);
    explicit RemoteLogModel(QString url, Analysis* parent=nullptr);

    // Accessors
    inline bool autoRefresh() const { return mAutoRefresh; }
    inline int autoRefreshInterval() const { return mAutoRefreshInterval; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QDateTime createDate() const { return mCreateDate; }
    inline QString url() const { return mLogUrl; }
    inline qint64 linesNumber() const { return mLinesNumber; }
    inline qint64 size() const { return mSize; }
    inline QString text() const { return mText; }
    inline QString searchPattern() const { return mSearchPattern; }
    inline QList<int> searchResult() const { return mSearchResult; }
    inline int cursorPosition() const { return mCursorPosition; }

    // Setters
    inline void setAutoRefresh(bool flag) { mAutoRefresh = flag; emit dataChanged(); }
    inline void setAutoRefreshInterval(int interval) { mAutoRefreshInterval = interval; emit dataChanged(); }
    inline void setSearchPattern(QString pattern) { search(pattern); }
    inline void setCursorPosition(int pos) { mCursorPosition = pos; emit cursorPositionChanged(); }

    // Methods
    Q_INVOKABLE void refresh();
    Q_INVOKABLE void search(QString search);


Q_SIGNALS:
    void dataChanged();
    void searchChanged();
    void cursorPositionChanged();


private:
    bool mAutoRefresh = false;
    int mAutoRefreshInterval = 5;
    QDateTime mUpdateDate;
    QDateTime mCreateDate;
    QDateTime mLastRefresh;
    QString mLogUrl;
    qint64 mLinesNumber;
    qint64 mSize;
    QString mText;
    QString mSearchPattern;
    QList<int> mSearchResult;
    int mCursorPosition = 0;
};

#endif // REMOTELOGMODEL_H
