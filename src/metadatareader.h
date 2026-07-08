#pragma once

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QMediaMetaData>
#include <QUrl>
#include <QQueue>

class MetadataReader : public QObject
{
    Q_OBJECT

public:
    explicit MetadataReader(QObject *parent = nullptr);
    ~MetadataReader();

    Q_INVOKABLE void readMetadata(const QUrl &url, int requestId = -1); //读取音频文件的元数据信息

signals:
    //readMetadata 函数的"回调",用于在元数据读取完成后，将结果返回给调用者
    void metadataReady(const QUrl &url, const QString &title, const QString &artist,
                       const QString &album, qint64 duration);

private slots:
    //用于监听 QMediaPlayer 的媒体状态变化事件，提取音频文件的元数据
    void onMediaStatusChanged(QMediaPlayer::MediaStatus status);

private:
    QMediaPlayer *m_player;      // 媒体播放器
    QAudioOutput *m_audioOutput; // 音频输出
    QUrl m_currentUrl;           // 当前正在读取的 URL
    int m_currentRequestId;      // 当前请求 ID
};
