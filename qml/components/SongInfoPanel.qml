//Module
//File: SongInfoPanel.qml
//Created:Guang Yang 2087167099@qq.com &&JunFeng Tu 2150319601@qq.com       2026-07-13
//Version: 2.0      License: AGPLv3
// Description: 歌曲信息区
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: "transparent"

    Layout.fillHeight: true
    Layout.minimumWidth: 200

    property bool liked: false

    RowLayout {
        anchors.fill: parent
        spacing: Style.spacingNormal

        // 专辑封面占位（网易云风格圆角方形）
        Rectangle {
            id: coverArt
            implicitWidth: 44
            implicitHeight: 44
            radius: Style.radiusSmall
            color: Style.bgTertiary
            border.width: 1
            border.color: Style.borderLight

            // 封面占位图标
            Text {
                anchors.centerIn: parent
                text: "\u266A"
                font.pixelSize: 20
                color: Style.textTertiary
            }
        }

        // 歌名 + 艺术家
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            // 歌名
            Text {
                id: titleText
                text: {
                    var idx = musicManager.playlistModel.currentIndex
                    if (idx >= 0 && idx < musicManager.playlistModel.count) {
                        var item = musicManager.playlistModel.get(idx)
                        return item.title || "未知歌曲"
                    }
                    return "未播放"
                }
                font.pixelSize: Style.fontSizeNormal
                font.bold: true
                color: Style.textPrimary
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // 艺术家
            Text {
                id: artistText
                text: {
                    var idx = musicManager.playlistModel.currentIndex
                    if (idx >= 0 && idx < musicManager.playlistModel.count) {
                        var item = musicManager.playlistModel.get(idx)
                        return item.artist || "未知艺术家"
                    }
                    return "请选择音乐文件"
                }
                font.pixelSize: Style.fontSizeSmall
                color: Style.textSecondary
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // 红心收藏按钮
        Button {
            implicitWidth: 32
            implicitHeight: 32
            flat: true
            text: root.liked ? "\u2665" : "\u2661"
            font.pixelSize: 18
            onClicked: root.liked = !root.liked

            contentItem: Text {
                text: parent.text
                font: parent.font
                color: root.liked ? Style.accentRed : Style.textSecondary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: parent.hovered ? Style.bgHover : "transparent"
                radius: Style.radiusSmall
            }
        }
    }
}