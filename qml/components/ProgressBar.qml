//Module
//File: ProgressBar.qml
//Created: Guang Yang 2087167099@qq.com       2026-07-13
//Version: 1.0      License: AGPLv3
//recover the progress
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgSecondary
    radius: Style.radiusNormal

    Layout.fillWidth: true
    Layout.preferredHeight: 60

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingNormal
        spacing: 5

        // 当前播放时间
        Text {
            text: Style.formatDuration(musicManager.position)
            font.pixelSize: Style.fontSizeSmall
            color: Style.textSecondary
        }

        //
        Slider {
            id: progressSlider
            Layout.fillWidth: true
            from: 0
            to: Math.max(musicManager.duration, 1)
            value: musicManager.position
            onMoved: musicManager.seek(value)

            // 背景自定义
            background: Rectangle {
                color: Style.bgTertiary
                radius: 4
                height: 6
            }

        }

        // 总时长
        Text {
            text: Style.formatDuration(musicManager.duration)
            font.pixelSize: Style.fontSizeSmall
            color: Style.textSecondary
        }
    }
}