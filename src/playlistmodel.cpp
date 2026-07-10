// Module
// File: playlistmodel.cpp   Version: 0.1.0   License: AGPLv3
// Created:Luojianqiu  2455043129@qq.com
// Description: Save and manage the information of all songs


#include "playlistmodel.h"
#include <QDebug>

PlaylistModel::PlaylistModel(QObject *parent)
    : QAbstractListModel(parent)    // 调用父类构造函数
    , m_currentIndex(-1)            // -1 表示没有播放任何歌曲
{
    qDebug() << "PlaylistModel initialized";
}

int PlaylistModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_songs.count();  // 返回歌曲总数
}

QVariant PlaylistModel::data(const QModelIndex &index, int role) const
{
    // 检查索引有没有效
    if (index.row() < 0 || index.row() >= m_songs.count())
        return QVariant();

    // 拿到这一行的歌曲数据
    const SongInfo &song = m_songs[index.row()];

    // 根据角色返回不同的字段
    switch (role) {
    case TitleRole:      return song.title;     // 标题
    case ArtistRole:     return song.artist;    // 艺术家
    case AlbumRole:      return song.album;     // 专辑
    case DurationRole:   return song.duration;  // 时长
    case UrlRole:        return song.url;       // 文件路径
    default:             return QVariant();     // 其他角色返回空
    }
}

QHash<int, QByteArray> PlaylistModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    // 把角色数字映射成名字
    roles[TitleRole] = "title";
    roles[ArtistRole] = "artist";
    roles[AlbumRole] = "album";
    roles[DurationRole] = "duration";
    roles[UrlRole] = "url";
    return roles;
}

int PlaylistModel::count() const
{
    return m_songs.count();  // 返回歌曲数量
}

int PlaylistModel::currentIndex() const
{
    return m_currentIndex;  // 返回当前播放到第几首，-1 表示没有
}


void PlaylistModel::setCurrentIndex(int index)
{
    // 只有索引变了才更新，避免重复发射信号
    if (m_currentIndex != index) {
        m_currentIndex = index;
        emit currentIndexChanged();  // 通知QML当前播放位置变了
    }
}

void PlaylistModel::addSong(const QUrl &url, const QString &title,
                            const QString &artist, const QString &album,
                            qint64 duration)
{

    SongInfo song;
    song.url = url;
    song.title = title;
    song.artist = artist;
    song.album = album;
    song.duration = duration;

    beginInsertRows(QModelIndex(), m_songs.count(), m_songs.count());

    m_songs.append(song);

    endInsertRows();

    emit countChanged();

    saveSongs();
}

void PlaylistModel::removeSong(int index)
{
    // 检查索引有没有效
    if (index < 0 || index >= m_songs.count())
        return;

    // 告诉视图要删除一行数据
    beginRemoveRows(QModelIndex(), index, index);

    // 真正删除数据
    m_songs.removeAt(index);

    // 更新显示
    endRemoveRows();

    //  如果当前播放的索引超出了范围，调整到最后一首
    if (m_currentIndex >= m_songs.count()) {
        setCurrentIndex(m_songs.count() - 1);
    }

    emit countChanged();

    saveSongs();
}


void PlaylistModel::clear()
{

    if (m_songs.isEmpty())
        return;

    beginResetModel();

    // 清空数据
    m_songs.clear();
    m_currentIndex = -1;  // 重置当前索引

    // 刷新
    endResetModel();

    emit countChanged();
    emit currentIndexChanged();

    saveSongs();
}

QUrl PlaylistModel::getUrl(int index) const
{
    // 检查索引有没有效
    if (index < 0 || index >= m_songs.count())
        return QUrl();  // 无效就返回空
    return m_songs[index].url;  // 返回歌曲的文件路径
}

void PlaylistModel::saveSongs() const
{
    // 创建设置对象（
    QSettings settings("QTmusic", "QTmusic");

    QVariantList list;
    list.reserve(m_songs.size());

    // 把每首歌转成 QVariantMap 格式，加到列表里
    for (const SongInfo &song : m_songs) {
        list.append(songToMap(song));
    }

    // 保存到硬盘
    settings.setValue("playlist/songs", list);          // 所有歌曲
    settings.setValue("playlist/currentIndex", m_currentIndex);  // 当前播放位置
}

void PlaylistModel::loadSongs()
{
    // 打开设置
    QSettings settings("QTmusic", "QTmusic");

    // 读取保存的歌曲列表
    QVariantList list = settings.value("playlist/songs").toList();

    // 如果没有数据就直接返回
    if (list.isEmpty())
        return;

    beginResetModel();

    // 清空当前数据
    m_songs.clear();

    // 遍历读取到的数据，转成SongInfo并添加到列表
    for (const QVariant &var : list) {
        QVariantMap map = var.toMap();
        if (!map.isEmpty())
            m_songs.append(songFromMap(map));
    }

    // 恢复当前播放索引
    m_currentIndex = settings.value("playlist/currentIndex", -1).toInt();

    // 如果索引超出了范围，重置为 -1
    if (m_currentIndex >= m_songs.count())
        m_currentIndex = -1;


    endResetModel();

    emit countChanged();
    emit currentIndexChanged();
}

QVariantMap PlaylistModel::songToMap(const SongInfo &song) const
{
    QVariantMap map;
    map["url"] = song.url.toString();      // QUrl 转成字符串
    map["title"] = song.title;
    map["artist"] = song.artist;
    map["album"] = song.album;
    map["duration"] = song.duration;
    return map;
}

SongInfo PlaylistModel::songFromMap(const QVariantMap &map) const
{
    SongInfo song;
    song.url = QUrl(map.value("url").toString());          // 字符串转回 QUrl
    song.title = map.value("title").toString();
    song.artist = map.value("artist").toString();
    song.album = map.value("album").toString();
    song.duration = map.value("duration").toLongLong();    // 转回整数
    return song;
}