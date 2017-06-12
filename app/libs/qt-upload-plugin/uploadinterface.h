/*********************************************************************
** Copyright © 2013 Nurul Arif Setiawan <n.arif.setiawan@gmail.com>
** All rights reserved.
**
** See the file "LICENSE.txt" for the full license governing this code
**
**********************************************************************/

#ifndef UPLOADINTERFACE_H
#define UPLOADINTERFACE_H

#include <QtPlugin>
#include <QObject>
#include <QString>
#include <QUrl>
#include <QList>

/**
 * RawHeaderPair <name, value>
 */
typedef QPair<QByteArray, QByteArray> RawHeaderPair;

/**
 * UploadResumePair <path, url>
 */
typedef QPair<QString, QString> UploadResumePair;

/**
 * UploadInterface is interface for upload implementation.
 * It provides several properties which must be set prior to use:
 * queue size, user agent, chunk size and upload url, upload protocol.
 *
 * This implementation use file path as unique keys for upload processes.
 *
 * It doesn't implement persistence storage for its upload queue and progress,
 * Storage should be implemented in the plugin host
 *
 * Support resumable upload via tus protocol
 * http://tus.io/protocols/resumable-upload.html
 */
class UploadInterface : public QObject
{
    Q_OBJECT

public:
    /**
     * Upload protocol options
     */
    enum UploadProtocol {
        ProtocolMultipart,
        ProtocolTus
    };

public:
    UploadInterface(QObject *parent) : QObject(parent) {}
    virtual ~UploadInterface() {}

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
     * Append an file path to upload queue and start upload when queue is within queue size.
     * \param path file path to upload.
     */
    virtual void append(const QString &path) = 0;

    /**
     * Append several file paths to upload queue and start upload when queue is within queue size.
     * \param pathList list of file paths to download.
     */
    virtual void append(const QStringList &pathList) = 0;

    /**
     * Pause an upload based on its path.
     * \param path file path to pause.
     */
    virtual void pause(const QString &path) = 0;

    /**
     * Pause several uploads based on its paths.
     * \param pathList list of file paths to pause.
     */
    virtual void pause(const QStringList &pathList) = 0;

    /**
     * Resume an upload based on its path.
     * \param path file path to resume.
     * \param submitUrl file url on upload server.
     */
    virtual void resume(const QString &path, const QString &submitUrl) = 0;

    /**
     * Resume several uploads based on its paths.
     * \param pathList list of file paths to resume.
     */
    virtual void resume(const QList<UploadResumePair> & pathList) = 0;

    /**
     * Stop an upload based on its path.
     * \param path file path to stop.
     */
    virtual void stop(const QString &path) = 0;

    /**
     * Stop several uploads based on its paths.
     * \param pathList list of file paths to stop.
     */
    virtual void stop(const QStringList &pathList) = 0;

    /**
     * Queue size.
     * Upload is started if current queue size is smaller the limit set
     */
    virtual void setQueueSize(int size) { m_queueSize = size; }
    inline int queueSize() { return m_queueSize; }

    /**
     * TODO :: Bandwidth limit implementation
     */
    virtual void setBandwidthLimit(int bytesPerSecond) = 0;
    inline int bandwidthLimit() { return m_bandwidthLimit; }

    /**
     * Tus protocol upload chunk size.
     */
    virtual void setChunkSize(int size) { m_chunkSize = size; }
    inline int chunkSize() { return m_chunkSize; }

    /**
     * Upload user agent.
     */
    inline void setUserAgent(const QByteArray &userAgent) { m_userAgent = userAgent; }
    inline QByteArray userAgent() { return m_userAgent; }

    /**
     * Tus upload patch verb. By protocol this should be PATCH, but server implementation might be different, i.e. using POST.
     */
    inline void setPatchVerb(const QByteArray &patchVerb) { m_patchVerb = patchVerb; }
    inline QByteArray patchVerb() { return m_patchVerb; }

    /**
     * Set upload protocol to use.
     */
    virtual void setUploadProtocol(UploadInterface::UploadProtocol protocol) { m_uploadProtocol = protocol; }
    inline UploadInterface::UploadProtocol uploadProtocol() { return m_uploadProtocol; }

    /**
     * Set upload url as destination.
     */
    inline void setUploadUrl(const QUrl &uploadUrl) { m_uploadUrl = uploadUrl; }
    inline QUrl uploadUrl() { return m_uploadUrl; }

    /**
     * Add additional headers for upload.
     * Added as requirement in one projects.
     */
    inline void setAdditionalHeader(QList<RawHeaderPair> &additionalHeaders) { m_additionalHeaders = additionalHeaders; }

signals:
    /**
     * Signal emitted when queue empty.
     */
    void queueEmpty();

    /**
     * Signal emitted when submitUrl is set and upload will begin.
     * In tus, we first register the file to server and server will send upload url to use.
     */
    void urlSet(const QString &path, const QString &url);

    /**
     * Signal emitted when upload complete.
     */
    void finished(const QString &path, const QString &submitUrl);

    /**
     * Signal emitted to update upload progress.
     */
    void progress(const QString &path, const qint64 bytesSent, const qint64 bytesTotal, const double percent, const double speed, const QString &unit);

    /**
     * Signal emitted to update upload status
     */
    void status(const QString &path, const QString &status, const QString &message, const QString &data);

protected:
    int m_queueSize;
    int m_bandwidthLimit;
    int m_chunkSize;
    QByteArray m_userAgent;
    QUrl m_uploadUrl;
    QByteArray m_patchVerb;
    UploadProtocol m_uploadProtocol;
    QList<RawHeaderPair> m_additionalHeaders;
};

Q_DECLARE_INTERFACE( UploadInterface, "com.infinite.app.uploader/1.0")

#endif // UPLOADINTERFACE_H
