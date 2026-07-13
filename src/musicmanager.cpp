// Module
// File: musicmanager.cpp   Version: 0.1.0   License: AGPLv3
// Created:LuoJianqiu 2455043129@qq.com
// Description: Realize functions to control playback modes and load local lyrics.

#include "musicmanager.h"
#include "playlistmodel.h"
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QRandomGenerator>
#include <QRegularExpression>
#include <QSettings>
#include <QTextStream>
#include <algorithm>



MusicManager::MusicManager(QObject *parent)
    : QObject(parent)
    , m_player(new QMediaPlayer(this))        // 创建播放器对象
    , m_audioOutput(new QAudioOutput(this))   // 创建音频输出对象
    , m_playlistModel(new PlaylistModel(this)) // 创建播放列表模型
    , m_lyricsSearcher(new LyricsSearcher(this)) // 创建歌词搜索器
    , m_currentIndex(-1)                      // -1 表示没有播放任何歌曲
    , m_playbackMode(Sequential)              // 默认顺序播放
    , m_currentLyricLine(-1)                  // -1 表示没有当前歌词行
{
    // 把音频输出设置给播放器
    m_player->setAudioOutput(m_audioOutput);

    // 显示占位歌词
    updatePlaceholderLyrics();


    // 当播放状态变化时，通知QML更新界面
    connect(m_player, &QMediaPlayer::playbackStateChanged,
            this, &MusicManager::onPlayerStateChanged);

    // 当歌曲时长变化时，通知QML更新进度条范围
    connect(m_player, &QMediaPlayer::durationChanged,
            this, &MusicManager::onDurationChanged);

    // 当播放位置变化时，通知QML更新进度条位置
    connect(m_player, &QMediaPlayer::positionChanged,
            this, &MusicManager::onPositionChanged);

    // 当媒体状态变化时，处理自动切换下一首
    connect(m_player, &QMediaPlayer::mediaStatusChanged,
            this, &MusicManager::onMediaStatusChanged);

    qDebug() << "MusicManager initialized";
}

MusicManager::~MusicManager()
{
    stop();          // 停止播放
    savePlaylist();  // 保存播放列表到硬盘
}

// 判断是否正在播放
bool MusicManager::isPlaying() const
{
    return m_player->playbackState() == QMediaPlayer::PlayingState;
}

// 获取当前歌曲的总时长
qint64 MusicManager::duration() const
{
    return m_player->duration();
}

// 获取当前播放位置
qint64 MusicManager::position() const
{
    return m_player->position();
}

// 跳转到指定位置
void MusicManager::setPosition(qint64 position)
{
    if (m_player->isSeekable()) {
        m_player->setPosition(position);
    }
}

// 获取当前音量
float MusicManager::volume() const
{
    return m_audioOutput->volume();
}

// 设置音量
void MusicManager::setVolume(float volume)
{
    m_audioOutput->setVolume(volume);
    emit volumeChanged(volume);  // 通知QML音量变了
}

// 获取播放列表模型
PlaylistModel* MusicManager::playlistModel() const
{
    return m_playlistModel;
}

// 获取歌词搜索器
LyricsSearcher* MusicManager::lyricsSearcher() const
{
    return m_lyricsSearcher;
}

// 播放
void MusicManager::play()
{
    // 如果没有当前播放索引但有歌曲，播放第一首
    if (m_currentIndex < 0 && m_playlistModel->count() > 0) {
        playIndex(0);
    } else {
        m_player->play();  // 继续播放当前歌曲
    }
}

// 暂停
void MusicManager::pause()
{
    m_player->pause();
}

// 停止
void MusicManager::stop()
{
    m_player->stop();
}

// 设置播放源
void MusicManager::setSource(const QUrl &url)
{
    m_player->setSource(url);
}

// 播放指定索引的歌曲
void MusicManager::playIndex(int index)
{
    // 检查索引是否有效
    if (index < 0 || index >= m_playlistModel->count()) {
        return;
    }

    // 更新当前索引
    m_currentIndex = index;
    m_playlistModel->setCurrentIndex(index);

    // 获取歌曲的URL
    QUrl url = m_playlistModel->getUrl(index);

    // 设置播放源
    m_player->setSource(url);

    // 加载歌词
    loadLyricsForUrl(url);

    // 开始播放
    m_player->play();
}

// 下一首
void MusicManager::next()
{
    int count = m_playlistModel->count();
    if (count == 0) {
        return;  //没有歌曲就不处理
    }

    int nextIndex = m_currentIndex;
    switch (m_playbackMode) {
    case LoopOne:
        // 单曲循环
        break;
    case Shuffle:
        // 随机播放
        nextIndex = nextShuffleIndex();
        break;
    case Sequential:
    default:
        // 顺序播放
        nextIndex = nextSequentialIndex();
        break;
    }
    playIndex(nextIndex);
}

// 上一首
void MusicManager::previous()
{
    int prevIndex = m_currentIndex - 1;
    if (prevIndex < 0) {
        prevIndex = m_playlistModel->count() - 1;  // 到第一首后跳到最后
    }
    playIndex(prevIndex);
}

// 跳转（QML 可调用）
void MusicManager::seek(qint64 position)
{
    setPosition(position);
}



// 播放状态变化时触发
void MusicManager::onPlayerStateChanged(QMediaPlayer::PlaybackState state)
{
    // 告诉QML播放状态变了
    emit isPlayingChanged(state == QMediaPlayer::PlayingState);
}

// 歌曲时长变化时触发
void MusicManager::onDurationChanged(qint64 duration)
{
    emit durationChanged(duration);  // 告诉QML更新进度条范围
}

// 播放位置变化时触发
void MusicManager::onPositionChanged(qint64 position)
{
    emit positionChanged(position);  // 告诉QML更新进度条位置

    // 更新当前歌词行
    if (m_lyrics.isEmpty()) {
        return;
    }

    int newLine = -1;
    for (int i = 0; i < m_lyrics.size(); ++i) {
        QVariantMap line = m_lyrics[i].toMap();
        int time = line.value("time").toInt();
        if (time <= position) {
            newLine = i;
        } else {
            break;
        }
    }
    setCurrentLyricLine(newLine);
}

// 媒体状态变化时触发
void MusicManager::onMediaStatusChanged(QMediaPlayer::MediaStatus status)
{
    if (status == QMediaPlayer::EndOfMedia) {  // 播放结束了
        if (m_playbackMode == LoopOne) {
            // 单曲循环
            m_player->setPosition(0);
            m_player->play();
        } else {
            // 其他模式
            next();
        }
    }
}

// 播放当前索引的歌曲
void MusicManager::playCurrentIndex()
{
    if (m_currentIndex >= 0 && m_currentIndex < m_playlistModel->count()) {
        QUrl url = m_playlistModel->getUrl(m_currentIndex);
        m_player->setSource(url);
        m_player->play();
    }
}

// 获取当前播放模式
int MusicManager::playbackMode() const
{
    return m_playbackMode;
}

// 设置播放模式
void MusicManager::setPlaybackMode(int mode)
{
    // 检查模式是否有效，以及是否改变了
    if (mode < Sequential || mode > LoopOne || m_playbackMode == mode) {
        return;
    }
    m_playbackMode = mode;
    emit playbackModeChanged(m_playbackMode);  // 通知QML更新显示
}

// 循环切换播放模式
void MusicManager::cyclePlaybackMode()
{
    int nextMode = m_playbackMode + 1;
    if (nextMode > LoopOne) {
        nextMode = Sequential;
    }
    setPlaybackMode(nextMode);
}

// 加载播放列表
void MusicManager::loadPlaylist()
{
    QSettings settings("QTmusic", "QTmusic");
    m_playlistModel->loadSongs();  // 恢复歌曲列表
    m_currentIndex = m_playlistModel->currentIndex();  // 恢复播放位置
    int mode = settings.value("playlist/playbackMode", Sequential).toInt();
    if (mode < Sequential || mode > LoopOne) {
        mode = Sequential;
    }
    setPlaybackMode(mode);
}

// 保存播放列表
void MusicManager::savePlaylist()
{
    QSettings settings("QTmusic", "QTmusic");
    m_playlistModel->saveSongs();  // 保存歌曲列表
    settings.setValue("playlist/playbackMode", m_playbackMode);  // 保存播放模式
}

// 获取歌词列表
QVariantList MusicManager::lyrics() const
{
    return m_lyrics;
}

// 获取当前歌词行索引
int MusicManager::currentLyricLine() const
{
    return m_currentLyricLine;
}

// 设置当前歌词行索引
void MusicManager::setCurrentLyricLine(int line)
{
    if (m_currentLyricLine != line) {
        m_currentLyricLine = line;
        emit currentLyricLineChanged();
    }
}

// 计算顺序播放的下一首索引
int MusicManager::nextSequentialIndex() const
{
    int nextIndex = m_currentIndex + 1;
    if (nextIndex >= m_playlistModel->count()) {
        nextIndex = 0;  // 到头了，回到第一首
    }
    return nextIndex;
}

// 计算随机播放的下一首索引
int MusicManager::nextShuffleIndex() const
{
    int count = m_playlistModel->count();
    if (count <= 1) {
        return m_currentIndex;
    }
    int nextIndex = m_currentIndex;
    while (nextIndex == m_currentIndex) {
        // 生成随机索引，直到跟当前不一样
        nextIndex = QRandomGenerator::global()->bounded(count);
    }
    return nextIndex;
}

// 显示占位歌词
void MusicManager::updatePlaceholderLyrics()
{
    m_lyrics.clear();
    m_lyrics.append(QVariantMap{{"time", 0}, {"text", "暂无歌词"}});
    m_lyrics.append(QVariantMap{{"time", 1000}, {"text", "请加载本地音乐欣赏"}});
    m_lyrics.append(QVariantMap{{"time", 2000}, {"text", "..."}});
    emit lyricsChanged();
}

// 加载歌词文件
void MusicManager::loadLyricsForUrl(const QUrl &audioUrl)
{
    m_lyrics.clear();

    if (!audioUrl.isLocalFile()) {
        updatePlaceholderLyrics();
        return;
    }

    QString audioPath = audioUrl.toLocalFile();
    QFileInfo audioInfo(audioPath);
    QString lrcPath = audioInfo.absolutePath() + "/" + audioInfo.completeBaseName() + ".lrc";

    QFile lrcFile(lrcPath);
    if (!lrcFile.exists() || !lrcFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        updatePlaceholderLyrics();
        return;
    }

    QTextStream stream(&lrcFile);
    stream.setEncoding(QStringConverter::Utf8);
    QList<QPair<int, QString>> parsedLines;

    QRegularExpression re("\\[(\\d+):(\\d+)\\.(\\d+)\\]");
    while (!stream.atEnd()) {
        QString line = stream.readLine();
        QRegularExpressionMatchIterator it = re.globalMatch(line);
        QList<int> timestamps;
        int firstMatchEnd = -1;
        while (it.hasNext()) {
            QRegularExpressionMatch match = it.next();
            int minutes = match.captured(1).toInt();
            int seconds = match.captured(2).toInt();
            QString fracStr = match.captured(3);
            int frac = fracStr.toInt();
            int msec = 0;
            if (fracStr.length() == 1) {
                msec = frac * 100;
            } else if (fracStr.length() == 2) {
                msec = frac * 10;
            } else {
                msec = frac;
            }
            int timeMs = minutes * 60000 + seconds * 1000 + msec;
            timestamps.append(timeMs);
            if (firstMatchEnd < 0) {
                firstMatchEnd = match.capturedEnd();
            }
        }

        if (timestamps.isEmpty()) {
            continue;
        }

        QString text = line.mid(firstMatchEnd).trimmed();
        for (int ts : timestamps) {
            parsedLines.append(qMakePair(ts, text));
        }
    }

    lrcFile.close();

    std::sort(parsedLines.begin(), parsedLines.end(),
              [](const QPair<int, QString> &a, const QPair<int, QString> &b) {
                  return a.first < b.first;
              });

    for (const auto &p : parsedLines) {
        QVariantMap entry;
        entry["time"] = p.first;
        entry["text"] = p.second;
        m_lyrics.append(entry);
    }

    if (m_lyrics.isEmpty()) {
        updatePlaceholderLyrics();
    }

    setCurrentLyricLine(-1);
    emit lyricsChanged();
}