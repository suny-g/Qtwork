// File:lyricssearcher.cpp   Version: 0.1.0   License: AGPLv3
// Created:Junfeng Tu  2150139603@qq.com
// Description: Implementation of lyrics search functionality

#include "lyricssearcher.h"
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <QTextStream>
#include <QStandardPaths>

LyricsSearcher::LyricsSearcher(QObject *parent)
    : QObject(parent)
{
}

QVariantList LyricsSearcher::searchLyrics(const QString &keyword) const
{
    QVariantList results;
    QString lowerKeyword = keyword.toLower().trimmed();

    if (lowerKeyword.isEmpty()) {
        return getAllLyrics();
    }

    QStringList paths = getSearchPaths();

    for (const QString &path : paths) {
        QDir dir(path);
        if (!dir.exists()) {
            continue;
        }

        QStringList lrcFiles = dir.entryList(QStringList() << "*.lrc", QDir::Files);
        for (const QString &fileName : lrcFiles) {
            QString filePath = dir.filePath(fileName);
            QString lowerFileName = fileName.toLower();

            if (lowerFileName.contains(lowerKeyword)) {
                QVariantMap info = parseLyricsInfo(filePath);
                if (!info.isEmpty()) {
                    results.append(info);
                }
            }
        }
    }

    return results;
}

QVariantList LyricsSearcher::getAllLyrics() const
{
    QVariantList results;
    QStringList paths = getSearchPaths();

    for (const QString &path : paths) {
        QDir dir(path);
        if (!dir.exists()) {
            continue;
        }

        QStringList lrcFiles = dir.entryList(QStringList() << "*.lrc", QDir::Files);
        for (const QString &fileName : lrcFiles) {
            QString filePath = dir.filePath(fileName);
            QVariantMap info = parseLyricsInfo(filePath);
            if (!info.isEmpty()) {
                results.append(info);
            }
        }
    }

    return results;
}

QString LyricsSearcher::readLyricsContent(const QString &filePath) const
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return QString();
    }

    QTextStream stream(&file);
    stream.setEncoding(QStringConverter::Utf8);
    QString content = stream.readAll();
    file.close();

    return content;
}

QStringList LyricsSearcher::getSearchPaths() const
{
    QStringList paths;

    paths << QDir::currentPath();
    paths << QStandardPaths::writableLocation(QStandardPaths::MusicLocation);
    paths << QStandardPaths::standardLocations(QStandardPaths::HomeLocation).first() + "/Music";
    paths << QStandardPaths::standardLocations(QStandardPaths::HomeLocation).first() + "/music";
    paths << QStandardPaths::standardLocations(QStandardPaths::HomeLocation).first() + "/Downloads";

    QDir rootDir("/mnt/study/learn");
    if (rootDir.exists()) {
        QStringList filters;
        filters << "*.lrc";
        QStringList lrcFiles = rootDir.entryList(filters, QDir::Files, QDir::NoSort);
        for (const QString &file : lrcFiles) {
            paths << rootDir.absoluteFilePath(file);
        }

        QStringList subDirs = rootDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
        for (const QString &subDir : subDirs) {
            QDir dir(rootDir.absoluteFilePath(subDir));
            QStringList subLrcFiles = dir.entryList(filters, QDir::Files, QDir::NoSort);
            for (const QString &file : subLrcFiles) {
                paths << dir.absoluteFilePath(file);
            }
        }
    }

    return paths;
}

QVariantMap LyricsSearcher::parseLyricsInfo(const QString &filePath) const
{
    QVariantMap info;
    QFileInfo fileInfo(filePath);

    QString content = readLyricsContent(filePath);
    QString title = extractTitleFromLrc(content);
    QString artist = extractArtistFromLrc(content);

    if (title.isEmpty()) {
        title = fileInfo.completeBaseName();
    }

    info["filePath"] = filePath;
    info["fileName"] = fileInfo.fileName();
    info["title"] = title;
    info["artist"] = artist;
    info["size"] = fileInfo.size();
    info["lastModified"] = fileInfo.lastModified().toString(Qt::ISODate);

    return info;
}

QString LyricsSearcher::extractArtistFromLrc(const QString &content) const
{
    QRegularExpression artistRegex(R"(^\[ar:(.*)\])", QRegularExpression::MultilineOption);
    QRegularExpressionMatch match = artistRegex.match(content);
    if (match.hasMatch()) {
        return match.captured(1).trimmed();
    }
    return QString();
}

QString LyricsSearcher::extractTitleFromLrc(const QString &content) const
{
    QRegularExpression titleRegex(R"(^\[ti:(.*)\])", QRegularExpression::MultilineOption);
    QRegularExpressionMatch match = titleRegex.match(content);
    if (match.hasMatch()) {
        return match.captured(1).trimmed();
    }
    return QString();
}
