// File:LyricsDisplay.qml   Version: 0.1.0   License: AGPLv3
// Created:Junfeng Tu  2150319601@qq.com
// Description: NetEase Cloud Music style lyrics display component

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgPrimary

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingLarge
        spacing: Style.spacingNormal

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingNormal

            Text {
                text: {
                    var idx = musicManager.playlistModel.currentIndex
                    if (idx >= 0 && idx < musicManager.playlistModel.count) {
                        var item = musicManager.playlistModel.get(idx)
                        return item.title || "未知歌曲"
                    }
                    return "歌词"
                }
                font.pixelSize: Style.fontSizeTitle
                font.bold: true
                color: Style.textPrimary
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: {
                    var idx = musicManager.playlistModel.currentIndex
                    if (idx >= 0 && idx < musicManager.playlistModel.count) {
                        var item = musicManager.playlistModel.get(idx)
                        return item.artist || "未知艺术家"
                    }
                    return ""
                }
                font.pixelSize: Style.fontSizeNormal
                color: Style.textSecondary
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgSecondary
            radius: Style.radiusNormal
            border.color: Style.borderNormal
            border.width: 1

            ListView {
                id: lyricsView
                anchors.fill: parent
                anchors.margins: Style.spacingNormal
                clip: true
                model: musicManager.lyrics
                currentIndex: musicManager.currentLyricLine
                highlightRangeMode: ListView.ApplyRange
                preferredHighlightBegin: (height - 60) / 2
                preferredHighlightEnd: (height + 60) / 2

                Behavior on contentY {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    visible: musicManager.lyrics.length === 0
                    text: "暂无歌词"
                    color: Style.textTertiary
                    font.pixelSize: Style.fontSizeNormal
                }

                delegate: Item {
                    width: lyricsView.width
                    height: 60

                    Text {
                        anchors.centerIn: parent
                        width: parent.width - 80
                        text: modelData.text || ""
                        color: index === musicManager.currentLyricLine ? Style.accentRed : Style.textSecondary
                        font.pixelSize: index === musicManager.currentLyricLine
                                       ? Style.fontSizeTitle : Style.fontSizeNormal
                        font.bold: index === musicManager.currentLyricLine
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
