// Module
// File: musicmanager.cpp   Version: 0.1.0   License: AGPLv3
// Created: Luojianqiu  2455043129@qq.com

#pragma once

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QUrl>
#include "playlistmodel.h"

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

    int playbackMode() const;  //获取当前的播放模式
    void setPlaybackMode(int mode);  //设置播放模式
    QVariantList lyrics() const;  //获取歌词列表

signals:
    void isPlayingChanged(bool isPlaying);  //通知QML播放状态变了
    void durationChanged(qint64 duration);  // 通知QML歌曲时长变了
    void positionChanged(qint64 position);  //通知QML播放位置变了
    void volumeChanged(float volume);  //通知QML音量变了
    void playbackModeChanged(int playbackMode);  // 通知QML播放模式变了
    void lyricsChanged();  //通知QML歌词更新

private slots:
    void onPlayerStateChanged(QMediaPlayer::PlaybackState state);  //通知QML更新界面
    void onDurationChanged(qint64 duration); //通知QML更新进度条的最大值
    void onPositionChanged(qint64 position);  //通知QML更新进度条
    void onMediaStatusChanged(QMediaPlayer::MediaStatus status); //监听媒体状态变化，处理播放结束自动切歌

private:
    void playCurrentIndex(); //重新播放当前索引指向的歌曲

    QMediaPlayer *m_player; //指向播放器
    QAudioOutput *m_audioOutput; //控制声音输出
    PlaylistModel *m_playlistModel; //存储所有歌曲数据
    int m_currentIndex;  //记录当前播放的是第几首歌
    int m_playbackMode;  //记录当前的播放模式
    QVariantList m_lyrics;  //存储歌词数据的列表

    int nextSequentialIndex() const;  //计算顺序模式下的下一首索引
    int nextShuffleIndex() const; //计算随机模式下的下一首索引
    void updatePlaceholderLyrics();  // 显示"暂无歌词"的占位文字
    void loadLyricsForUrl(const QUrl &audioUrl);  //加载某首歌对应的歌词文件
};