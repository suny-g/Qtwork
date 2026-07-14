//
//File: PlaybackControls.qml
//Created: Guang Yang 2087167099@qq.com       2026-07-13
//Version: 2.0      License: AGPLv3
// Description: 格播放控制
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: "transparent"

    Layout.fillHeight: true
    Layout.minimumWidth: 220

    RowLayout {
        anchors.centerIn: parent
        spacing: Style.spacingLarge

        // 播放模式切换
        Button {
            implicitWidth: 28
            implicitHeight: 28
            flat: true
            font.pixelSize: 14
            text: {
                switch (musicManager.playbackMode) {
                case 0: return "\u{1F501}"
                case 1: return "\u{1F500}"
                case 2: return "\u{1F502}"
                default: return "\u{1F501}"
                }
            }
            onClicked: musicManager.cyclePlaybackMode()

            ToolTip.text: {
                switch (musicManager.playbackMode) {
                    case 0: return "顺序播放"
                    case 1: return "随机播放"
                    case 2: return "单曲循环"
                    default: return "顺序播放"
                }
            }
            ToolTip.visible: hovered

            background: Rectangle {
                color: parent.hovered ? Style.bgHover : "transparent"
                radius: Style.radiusSmall
            }
        }

        // 上一首
        Button {
            implicitWidth: 32
            implicitHeight: 32
            flat: true
            text: "\u23EE"
            font.pixelSize: 18
            enabled: musicManager.playlistModel.count > 0
            onClicked: musicManager.previous()

            background: Rectangle {
                color: parent.hovered ? Style.bgHover : "transparent"
                radius: Style.radiusSmall
            }
        }

        //播放/暂停
        Button {
            implicitWidth: 44
            implicitHeight: 44
            flat: true
            text: musicManager.isPlaying ? "\u23F8" : "\u25B6"
            font.pixelSize: 22
            enabled: musicManager.playlistModel.count > 0
            onClicked: {
                if (musicManager.isPlaying) {
                    musicManager.pause()
                } else {
                    musicManager.play()
                }
            }

            background: Rectangle {
                implicitWidth: 44
                implicitHeight: 44
                radius: 22
                color: parent.hovered ? Style.accentRedHover : Style.accentRed
            }
        }

        //下一首
        Button {
            implicitWidth: 32
            implicitHeight: 32
            flat: true
            text: "\u23ED"
            font.pixelSize: 18
            enabled: musicManager.playlistModel.count > 0
            onClicked: musicManager.next()

            background: Rectangle {
                color: parent.hovered ? Style.bgHover : "transparent"
                radius: Style.radiusSmall
            }
        }

        //播放列表快捷图标
        Button {
            implicitWidth: 28
            implicitHeight: 28
            flat: true
            text: "\u{1F3B5}"
            font.pixelSize: 14
            ToolTip.text: "播放列表"
            ToolTip.visible: hovered

            background: Rectangle {
                color: parent.hovered ? Style.bgHover : "transparent"
                radius: Style.radiusSmall
            }
       }
    }
}