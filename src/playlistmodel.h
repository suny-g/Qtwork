#pragma once

#include <QAbstractListModel>
#include <QSettings>
#include <QUrl>
#include <QVariant>
#include <QVector>

struct SongInfo
{
    QString title; // 歌曲标题
    QString artist; // 艺术家
    QString album; // 专辑名称
    qint64 duration; // 时长（毫秒）
    QUrl url; // 文件路径 URL
};

class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)

public:

    enum Roles {
        TitleRole = Qt::UserRole + 1,   // 标题
        ArtistRole,                     // 作家
        AlbumRole,                      // 专辑
        DurationRole,                   // 时长
        UrlRole                         // 文件URL
    };

    explicit PlaylistModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override; //返回列表中的数据行数
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override; //返回指定行和角色的数据
    QHash<int, QByteArray> roleNames() const override; //返回角色枚举值到字符串的映射

    int count() const; //返回当前播放列表的歌曲总数
    int currentIndex() const; //返回当前正在播放的歌曲索引
    void setCurrentIndex(int index); //设置当前播放索引

    //将 C++ 函数暴露给 QML
    Q_INVOKABLE void addSong(const QUrl &url, const QString &title,
                             const QString &artist, const QString &album,
                             qint64 duration); //向播放列表添加一首新歌曲
    Q_INVOKABLE void removeSong(int index); //从播放列表中移除指定索引的歌曲
    Q_INVOKABLE void clear();  //清空整个播放列表
    Q_INVOKABLE QUrl getUrl(int index) const; //返回指定索引歌曲的文件URL

    void saveSongs() const;  //将播放列表保存到持久化存储
    void loadSongs();  //从持久化存储恢复播放列表

signals:
    void countChanged();        // 歌曲数量变化时发射
    void currentIndexChanged(); // 当前索引变化时发射

private:

    QVariantMap songToMap(const SongInfo &song) const; // 将 SongInfo 对象转换为 QVariantMap，用于持久化存储
    SongInfo songFromMap(const QVariantMap &map) const;  //从 QVariantMap 恢复 SongInfo 对象，用于从持久化存储加载数据。
    QVector<SongInfo> m_songs;  //存储所有歌曲数据
    int m_currentIndex;  //存储当前正在播放的歌曲索引
};
