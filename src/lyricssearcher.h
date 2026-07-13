// File:lyricssearcher.h   Version: 0.1.0   License: AGPLv3
// Created:Junfeng Tu  2150139603@qq.com
// Description: Lyrics searcher class for searching local .lrc files

#pragma once

#include <QObject>
#include <QVariantList>
#include <QString>

class LyricsSearcher : public QObject
{
    Q_OBJECT

public:
    explicit LyricsSearcher(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList searchLyrics(const QString &keyword) const;
    Q_INVOKABLE QVariantList getAllLyrics() const;
    Q_INVOKABLE QString readLyricsContent(const QString &filePath) const;

private:
    QStringList getSearchPaths() const;
    QVariantMap parseLyricsInfo(const QString &filePath) const;
    QString extractArtistFromLrc(const QString &content) const;
    QString extractTitleFromLrc(const QString &content) const;
};
