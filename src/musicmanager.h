#pragma once

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QUrl>
#include "playlistmodel.h"

class MusicManager : public QObject
{
    Q_OBJECT

public:
    enum PlaybackMode {
        Sequential = 0,  // 顺序播放
        Shuffle,         // 随机播放
        LoopOne          // 单曲循环
    };

    explicit MusicManager(QObject *parent = nullptr);
    ~MusicManager();

    bool isPlaying() const; //查询当前是否有音乐正在播放
    qint64 duration() const; //返回当前播放歌曲的总时长
    qint64 position() const; // 返回当前播放位置
    void setPosition(qint64 position); //用于跳转到歌曲的指定播放位置
    float volume() const; //返回当前音量值
    void setVolume(float volume); //设置音量值
    PlaylistModel* playlistModel() const; //返回播放列表模型的指针
};