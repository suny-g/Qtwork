#include "metadatareader.h"
#include <QDebug>

MetadataReader::MetadataReader(QObject *parent)
    : QObject(parent)
    , m_player(new QMediaPlayer(this))
    , m_audioOutput(new QAudioOutput(this))
    , m_currentRequestId(-1)
{
    m_player->setAudioOutput(m_audioOutput);
    m_audioOutput->setMuted(true);  // 静音，只读取元数据不播放

    connect(m_player, &QMediaPlayer::mediaStatusChanged,
            this, &MetadataReader::onMediaStatusChanged);

    qDebug() << "MetadataReader initialized";
}

MetadataReader::~MetadataReader()
{
}

void MetadataReader::readMetadata(const QUrl &url, int requestId)
{
    m_currentUrl = url;
    m_currentRequestId = requestId;
    m_player->setSource(url);  // 开始加载媒体
}

void MetadataReader::onMediaStatusChanged(QMediaPlayer::MediaStatus status)
{
    // 检查是否已加载完成
    if (status == QMediaPlayer::LoadedMedia ||
        status == QMediaPlayer::BufferedMedia ||
        status == QMediaPlayer::StalledMedia) {

        // 获取元数据
        QMediaMetaData metaData = m_player->metaData();
        // 提取各字段，使用 value() 获取并转换为字符串
        QString title = metaData.value(QMediaMetaData::Title).toString();
        QString artist = metaData.value(QMediaMetaData::ContributingArtist).toString();
        QString album = metaData.value(QMediaMetaData::AlbumTitle).toString();
        qint64 duration = m_player->duration();

        // 如果标题为空，使用文件名作为标题
        if (title.isEmpty()) {
            title = m_currentUrl.fileName();
        }

        // 发射结果信号
        emit metadataReady(m_currentUrl, title, artist, album, duration);

        // 停止播放器释放资源
        m_player->stop();
    }
}
