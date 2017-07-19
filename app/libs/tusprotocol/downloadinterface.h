/*********************************************************************
** Copyright © 2013 Nurul Arif Setiawan <n.arif.setiawan@gmail.com>
** All rights reserved.
**
** See the file "LICENSE.txt" for the full license governing this code
**
**********************************************************************/

#ifndef DOWNLOADINTERFACE_H
#define DOWNLOADINTERFACE_H

#include <QtPlugin>
#include <QObject>
#include <QString>
#include <QPair>
#include <QList>

/**
 * DownloadResumePair <url, path>
 */
typedef QPair<QString, QString> DownloadResumePair;

/**
 * DownloadInterface is interface for download implementation.
 * It provides several properties which must be set prior to use:
 * queue size, user agent, file path and download policies.
 *
 * This implementation use url as unique keys for download processes.
 *
 * It doesn't implement persistence storage for its download queue and progress,
 * Storage should be implemented in the plugin host
 */
class DownloadInterface : public QObject
{
    Q_OBJECT

public:
    /**
     * Policy when file with same name exists in disk.
     * File name is derived from url basename.
     */
    enum AlreadyExistPolicy {
        ExistThenCancel,
        ExistThenOverwrite,
        ExistThenRename
    };

    /**
     * Policy when partial file with same name exists in disk.
     * Partial file name is derived from url basename appended with .part
     */
    enum PartialExistPolicy {
        PartialThenContinue,
        PartialThenRestart
    };

public:
    DownloadInterface(QObject *parent) : QObject(parent) {}
    virtual ~DownloadInterface() {}

    /**
     * This plugin name.
     */
    virtual QString name() const = 0;

    /**
     * This plugin version.
     */
    virtual QString version() const = 0;

    /**
     * Set default parameters (properties) for download plugins.
     */
    virtual void setDefaultParameters() = 0;

    /**
     * Append an url to download queue and start download when queue is within queue size.
     * \param url file url to download.
     */
    virtual void append(const QString &url) = 0;

    /**
     * Append several urls to download queue and start download when queue is within queue size.
     * \param urlList list of file urls to download.
     */
    virtual void append(const QStringList &urlList) = 0;

    /**
     * Pause a download based on its url.
     * \param url file url to pause.
     */
    virtual void pause(const QString &url) = 0;

    /**
     * Pause several downloads based on its urls.
     * \param urlList list of file urls to pause.
     */
    virtual void pause(const QStringList &urlList) = 0;

    /**
     * Resume a download based on its url.
     * \param url file url to resume.
     * \param path file path in disk.
     */
    virtual void resume(const QString &url, const QString &path = "") = 0;

    /**
     * Resume several downloads based on its urls.
     * \param urlList list of file urls to resume.
     */
    virtual void resume(const QList<DownloadResumePair> & urlList) = 0;

    /**
     * Stop a download based on its url.
     * \param url file url to stop.
     */
    virtual void stop(const QString &url) = 0;

    /**
     * Stop several downloads based on its urls.
     * \param urlList list of file urls to stop.
     */
    virtual void stop(const QStringList &urlList) = 0;

    /**
     * Queue size.
     * Download is started if current queue size is smaller the limit set
     */
    inline void setQueueSize(int size) { m_queueSize = size; }
    inline int queueSize() { return m_queueSize; }

    /**
     * TODO :: Bandwidth limit implementation
     */
    virtual void setBandwidthLimit(int bytesPerSecond) = 0;
    inline int bandwidthLimit() { return m_bandwidthLimit; }

    /**
     * File path.
     * Directory where to put downloads file.
     */
    inline void setFilePath(const QString &path) { m_filePath = path; }
    inline QString filePath() { return m_filePath; }

    /**
     * Downloader user agent.
     */
    inline void setUserAgent(const QByteArray &userAgent) { m_userAgent = userAgent; }
    inline QByteArray userAgent() { return m_userAgent; }

    /**
     * Already exist policy.
     * Policy when file with same name exists in disk.
     * \param existPolicy #ExistThenCancel or #ExistThenOverwrite or #ExistThenRename
     */
    virtual void setExistPolicy(DownloadInterface::AlreadyExistPolicy existPolicy) { m_existPolicy = existPolicy; }
    inline DownloadInterface::AlreadyExistPolicy existPolicy() { return m_existPolicy; }

    /**
     * Partial exist policy.
     * Policy when partial file with same name exists in disk.
     * \param existPolicy #PartialThenContinue or #PartialThenRestart
     */
    virtual void setPartialPolicy(DownloadInterface::PartialExistPolicy partialPolicy) { m_partialPolicy = partialPolicy; }
    inline DownloadInterface::PartialExistPolicy partialPolicy() { return m_partialPolicy; }

signals:
    /**
     * Signal emitted when queue empty.
     */
    void queueEmpty();

    /**
     * Signal emitted when file name is set and download will begin.
     */
    void filenameSet(const QString &url, const QString &fileName);

    /**
     * Signal emitted when download complete.
     */
    void finished(const QString &url, const QString &fileName);

    /**
     * Signal emitted to update download progress.
     */
    void progress(const QString &url, const qint64 bytesReceived, const qint64 bytesTotal, const double percent, const double speed, const QString &unit);

    /**
     * Signal emitted to update download status
     */
    void status(const QString &url, const QString &status, const QString &message, const QString &data);

protected:
    int m_queueSize;
    int m_bandwidthLimit;
    QString m_filePath;
    QByteArray m_userAgent;
    AlreadyExistPolicy m_existPolicy;
    PartialExistPolicy m_partialPolicy;
};

Q_DECLARE_INTERFACE( DownloadInterface, "com.infinite.app.downloader/1.0")

#endif // DOWNLOADINTERFACE_H
