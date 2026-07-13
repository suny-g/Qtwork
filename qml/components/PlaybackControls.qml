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

        Button {
            text: "⏮"
            font.pixelSize: 24
            enabled: musicManager.playlistModel.count > 0
            onClicked: musicManager.previous()
            background: Rectangle {
                color: parent.hovered ? Style.bgHover : Style.bgTertiary
                radius: Style.radiusNormal
            }
        }

        Button {
            text: musicManager.isPlaying ? "⏸" : "▶"
            font.pixelSize: 32
            enabled: musicManager.playlistModel.count > 0
            onClicked: {
                if (musicManager.isPlaying) {
                    musicManager.pause()
                } else {
                    musicManager.play()
                }
            }
            background: Rectangle {
                color: parent.hovered ? Style.accentRedHover : Style.accentRed
                radius: Style.radiusNormal
            }
        }

        Button {
            text: "⏭"
            font.pixelSize: 24
            enabled: musicManager.playlistModel.count > 0
            onClicked: musicManager.next()
            background: Rectangle {
                color: parent.hovered ? Style.bgHover : Style.bgTertiary
                radius: Style.radiusNormal
            }
        }

        Button {
            text: "⏹"
            font.pixelSize: 24
            enabled: musicManager.isPlaying
            onClicked: musicManager.stop()
            background: Rectangle {
                color: parent.hovered ? Style.bgHover : Style.bgTertiary
                radius: Style.radiusNormal
            }
        }

        Button {
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
            ToolTip.visible: hovered
            background: Rectangle {
                color: parent.hovered ? Style.bgHover : Style.bgTertiary
                radius: Style.radiusNormal
            }
        }
    }
}