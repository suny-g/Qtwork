// Module
// File: musicmanager.h   Version: 0.1.0   License: AGPLv3
// Created: Luojianqiu  2455043129@qq.com
// Description: Music playback manager with playlist, lyrics and playback modes

#pragma once

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QUrl>
#include <QMap>
#include "playlistmodel.h"
#include "lyricssearcher.h"

class MusicManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(float volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(PlaylistModel* playlistModel READ playlistModel CONSTANT)
    Q_PROPERTY(int playbackMode READ playbackMode WRITE setPlaybackMode NOTIFY playbackModeChanged)
    Q_PROPERTY(QVariantList lyrics READ lyrics NOTIFY lyricsChanged)
    Q_PROPERTY(LyricsSearcher* lyricsSearcher READ lyricsSearcher CONSTANT)
    Q_PROPERTY(int currentLyricLine READ currentLyricLine NOTIFY currentLyricLineChanged)

public:
    enum PlaybackMode {
        Sequential = 0,  // 顺序播放
        Shuffle,         // 随机播放
        LoopOne          // 单曲循环
    };
    Q_ENUM(PlaybackMode)

    explicit MusicManager(QObject *parent = nullptr);
    ~MusicManager();

    bool isPlaying() const; //查询当前是否有音乐正在播放
    qint64 duration() const; //返回当前播放歌曲的总时长
    qint64 position() const; // 返回当前播放位置
    void setPosition(qint64 position); //用于跳转到歌曲的指定播放位置
    float volume() const; //返回当前音量值
    //void setVolume(float volume); //设置音量值
    Q_INVOKABLE void setVolume(float volume); //设置音量值
    PlaylistModel* playlistModel() const; //返回播放列表模型的指针

    Q_INVOKABLE void play(); //播放音乐
    Q_INVOKABLE void pause(); //暂停播放
    Q_INVOKABLE void stop();  // 停止播放
    Q_INVOKABLE void setSource(const QUrl &url); //设置要播放的文件
    Q_INVOKABLE void playIndex(int index);  //播放播放列表中指定索引的歌曲
    Q_INVOKABLE void next();  //播放下一首
    Q_INVOKABLE void previous();  //播放上一首
    Q_INVOKABLE void seek(qint64 position);  //跳转到指定播放位置
    Q_INVOKABLE void cyclePlaybackMode();  //循环切换播放模式
    Q_INVOKABLE void loadPlaylist();  // 从硬盘加载之前保存的播放列表
    void savePlaylist();

    LyricsSearcher* lyricsSearcher() const;  //获取歌词搜索器

    int playbackMode() const;  //获取当前的播放模式
    void setPlaybackMode(int mode);  //设置播放模式
    QVariantList lyrics() const;  //获取歌词列表
    int currentLyricLine() const;  //获取当前歌词行索引
    void setCurrentLyricLine(int line);  //设置当前歌词行索引

signals:
    void isPlayingChanged(bool isPlaying);  //通知QML播放状态变了
    void durationChanged(qint64 duration);  // 通知QML歌曲时长变了
    void positionChanged(qint64 position);  //通知QML播放位置变了
    void volumeChanged(float volume);  //通知QML音量变了
    void playbackModeChanged(int playbackMode);  // 通知QML播放模式变了
    void lyricsChanged();  //通知QML歌词更新
    void currentLyricLineChanged();  //通知QML当前歌词行变化

private slots:
    void onPlayerStateChanged(QMediaPlayer::PlaybackState state);  //通知QML更新界面
    void onDurationChanged(qint64 duration); //通知QML更新进度条的最大值
    void onPositionChanged(qint64 position);  //通知QML更新进度条
    void onMediaStatusChanged(QMediaPlayer::MediaStatus status); //监听媒体状态变化，处理播放结束自动切歌

private:
    void playCurrentIndex();

    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;
    PlaylistModel *m_playlistModel;
    LyricsSearcher *m_lyricsSearcher;
    int m_currentIndex;
    int m_playbackMode;
    QVariantList m_lyrics;
    int m_currentLyricLine;
    QMap<QString, QVariantList> m_lyricsCache; // 歌词缓存

    int nextSequentialIndex() const;
    int nextShuffleIndex() const;
    void updatePlaceholderLyrics();
    void loadLyricsForUrl(const QUrl &audioUrl);
    QVariantList parseLyricsContent(const QString &content); // 解析歌词内容
};