// Module
// File: metadatareader.cpp   Version: 0.1.0   License: AGPLv3
// Created:LuoJianqiu 2455043129@qq.com
// Description: Read metadata including song titles, supports batch requests

#include "metadatareader.h"
#include <QDebug>

MetadataReader::MetadataReader(QObject *parent)
    : QObject(parent)
    , m_player(new QMediaPlayer(this))
    , m_audioOutput(new QAudioOutput(this))
    , m_isProcessing(false)
{
    m_player->setAudioOutput(m_audioOutput);
    m_audioOutput->setMuted(true);

    connect(m_player, &QMediaPlayer::mediaStatusChanged,
            this, &MetadataReader::onMediaStatusChanged);

    qDebug() << "MetadataReader initialized";
}

MetadataReader::~MetadataReader()
{
}

void MetadataReader::readMetadata(const QUrl &url, int requestId)
{
    m_requestQueue.enqueue({url, requestId});
    if (!m_isProcessing) {
        processNextRequest();
    }
}

void MetadataReader::processNextRequest()
{
    if (m_requestQueue.isEmpty()) {
        m_isProcessing = false;
        return;
    }

    m_isProcessing = true;
    Request request = m_requestQueue.dequeue();
    m_player->setSource(request.url);
}

void MetadataReader::onMediaStatusChanged(QMediaPlayer::MediaStatus status)
{
    if (status == QMediaPlayer::LoadedMedia ||
        status == QMediaPlayer::BufferedMedia) {

        QMediaMetaData metaData = m_player->metaData();
        QString title = metaData.value(QMediaMetaData::Title).toString();
        QString artist = metaData.value(QMediaMetaData::ContributingArtist).toString();
        QString album = metaData.value(QMediaMetaData::AlbumTitle).toString();
        qint64 duration = m_player->duration();

        if (title.isEmpty()) {
            title = m_player->source().fileName();
        }

        emit metadataReady(m_player->source(), title, artist, album, duration);

        m_player->stop();
        processNextRequest();
    } else if (status == QMediaPlayer::InvalidMedia) {
        qWarning() << "[MetadataReader] Invalid media:" << m_player->source().toString();
        m_player->stop();
        processNextRequest();
    }
}
