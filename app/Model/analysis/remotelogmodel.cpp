#include "remotelogmodel.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"


RemoteLogModel::RemoteLogModel(QObject* parent) : QObject(parent)
{
}
RemoteLogModel::RemoteLogModel(QString url, Analysis* parent) : QObject(parent)
{
    mLogUrl = url;
    refresh();
}


void RemoteLogModel::refresh()
{
    // Need to download file
    Request* req = Request::download(mLogUrl);
    connect(req, &Request::downloadReceived, [this, req](bool success, const QByteArray& data)
    {
        if (success)
        {
            mText = QString(data);
            mCursorPosition = mText.size();
            mSize = qint64(data.size());
            mLastRefresh = QDateTime::currentDateTime();
            search(mSearchPattern);
            emit dataChanged();
        }
        else
        {
            // TODO: create json error from scratch
            QJsonObject jsonError;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->manageRequestError(jsonError, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
}



void RemoteLogModel::search(QString search)
{
    search = search.trimmed();
    if (search.isEmpty())
    {
        mSearchPattern = "";
        mSearchResult.clear();
        emit searchChanged();
    }
    else if (mSearchPattern != search)
    {
        mSearchPattern = search;
        mSearchResult.clear();
        if (!mSearchPattern.isEmpty())
        {
            int j = 0;
            while ( (j = mText.indexOf(mSearchPattern, j, Qt::CaseInsensitive)) != -1)
            {
                mSearchResult.append(j);
                ++j;
            }
        }
        mCursorPosition = mSearchResult.count() > 0 ? mSearchResult[0] : mCursorPosition;
        emit searchChanged();
    }
}


