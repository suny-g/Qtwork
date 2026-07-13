// File:LyricsDisplay.qml   Version: 0.1.0   License: AGPLv3
// Created:Junfeng Tu  2150139603@qq.com
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

            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.spacingNormal
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Style.spacingLarge

                    Repeater {
                        model: musicManager.lyrics
                        delegate: Text {
                            text: modelData.text || ""
                            font.pixelSize: Style.fontSizeNormal
                            color: index === musicManager.currentLyricLine ? Style.accentRed : Style.textSecondary
                            font.bold: index === musicManager.currentLyricLine
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            width: parent.width * 0.8
                            padding: Style.spacingSmall
                        }
                    }
                }
            }
        }
    }
}
