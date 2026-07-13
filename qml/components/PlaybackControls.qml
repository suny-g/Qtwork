//
//File: PlaybackControls.qml
//Created: Guang Yang 2087167099@qq.com       2026-07-13
//Version: 1.0      License: AGPLv3
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgSecondary
    radius: Style.radiusNormal

    Layout.fillWidth: true
    Layout.preferredHeight: 80

    RowLayout {
        anchors.centerIn: parent
        spacing: Style.spacingLarge

        // 上一首
        Button {
            id: prevBtn
            implicitWidth: 44
            implicitHeight: 44
            text: "⏮"
            font.pixelSize: 24
            enabled: musicManager.playlistModel.count > 0
            onClicked: musicManager.previous()
            background: Rectangle {
                color: prevBtn.hovered ? Style.bgHover : Style.bgTertiary
                radius: Style.radiusNormal
            }
        }

        // 播放/暂停
        Button {
            id: playBtn
            implicitWidth: 44
            implicitHeight: 44
            text: musicManager.isPlaying ? "⏸" : "▶"
            font.pixelSize: 24
            enabled: musicManager.playlistModel.count > 0
            onClicked: {
                if (musicManager.isPlaying) {
                    musicManager.pause()
                } else {
                    musicManager.play()
                }
            }
            background: Rectangle {
                color: playBtn.hovered ? Style.accentRedHover : Style.accentRed
                radius: Style.radiusNormal
            }
        }

        // 下一首
        Button {
            id: nextBtn
            implicitWidth: 44
            implicitHeight: 44
            text: "⏭"
            font.pixelSize: 24
            enabled: musicManager.playlistModel.count > 0
            onClicked: musicManager.next()
            background: Rectangle {
                color: nextBtn.hovered ? Style.bgHover : Style.bgTertiary
                radius: Style.radiusNormal
            }
        }

        // 停止
        Button {
            id: stopBtn
            implicitWidth: 44
            implicitHeight: 44
            text: "⏹"
            font.pixelSize: 24
            enabled: musicManager.isPlaying
            onClicked: musicManager.stop()
            background: Rectangle {
                color: stopBtn.hovered ? Style.bgHover : Style.bgTertiary
                radius: Style.radiusNormal
            }
        }

        // 播放模式切换
        Button {
            id: modeBtn
            implicitWidth: 44
            implicitHeight: 44
            text: {
                switch (musicManager.playbackMode) {
                    case 0: return "🔁 顺序"
                    case 1: return "🔀 随机"
                    case 2: return "🔂 单曲"
                    default: return "🔁 顺序"
                }
            }
            font.pixelSize: 12
            onClicked: musicManager.cyclePlaybackMode()
            ToolTip.text: {
                switch (musicManager.playbackMode) {
                    case 0: return "顺序播放"
                    case 1: return "随机播放"
                    case 2: return "单曲循环"
                    default: return "顺序播放"
                }
            }
            ToolTip.visible: modeBtn.hovered
            background: Rectangle {
                color: modeBtn.hovered ? Style.bgHover : Style.bgTertiary
                radius: Style.radiusNormal
            }
        }
    }
}
