//Module
//File: ProgressBar.qml
//Created: Guang Yang 2087167099@qq.com       2026-07-13
//Version: 2.0      License: AGPLv3
// Description: progressbar like netease cloud
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: "transparent"

    Layout.fillWidth: true
    Layout.preferredHeight: 24

    RowLayout {
        anchors.fill: parent
        spacing: Style.spacingSmall

        // 左侧：当前播放时间
        Text {
            text: Style.formatDuration(musicManager.position)
            font.pixelSize: Style.fontSizeMini
            color: Style.textTertiary
            Layout.minimumWidth: 32
            horizontalAlignment: Text.AlignRight
        }

        // 中间：进度滑块
        Slider {
            id: progressSlider
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            from: 0
            to: Math.max(musicManager.duration, 1)
            value: musicManager.position
            onMoved: musicManager.seek(value)

            background: Rectangle {
                x: progressSlider.leftPadding
                y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 3
                width: progressSlider.availableWidth
                height: implicitHeight
                radius: 1.5
                color: Style.bgTertiary

                // 已播放进度
                Rectangle {
                    width: progressSlider.visualPosition * parent.width
                    height: parent.height
                    radius: 1.5
                    color: Style.accentRed
                }
            }

            handle: Rectangle {
                x: progressSlider.leftPadding + progressSlider.visualPosition * (progressSlider.availableWidth - width)
                y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                implicitWidth: 10
                implicitHeight: 10
                radius: 5
                color: Style.accentRed
                visible: progressSlider.hovered || progressSlider.pressed
            }
        }

        // 右侧：总时长
        Text {
            text: Style.formatDuration(musicManager.duration)
            font.pixelSize: Style.fontSizeMini
            color: Style.textTertiary
            Layout.minimumWidth: 32
            horizontalAlignment: Text.AlignLeft
        }
    }
}