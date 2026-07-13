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

        Text {
            text: Style.formatDuration(musicManager.position)
            font.pixelSize: Style.fontSizeSmall
            color: Style.textSecondary
        }

        Slider {
            id: progressSlider
            Layout.fillWidth: true
            from: 0
            to: Math.max(musicManager.duration, 1)
            value: musicManager.position
            onMoved: musicManager.seek(value)

            background: Rectangle {
                color: Style.bgTertiary
                radius: 4
                height: 6
            }

            handle: Rectangle {
                x: progressSlider.leftPadding + progressSlider.visualPosition * (progressSlider.availableWidth - width)
                y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                width: 16
                height: 16
                radius: 8
                color: Style.accentRed
            }
        }

        Text {
            text: Style.formatDuration(musicManager.duration)
            font.pixelSize: Style.fontSizeSmall
            color: Style.textSecondary
        }
    }
}