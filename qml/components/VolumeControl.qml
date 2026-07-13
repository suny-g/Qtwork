//Module
//File: VolumeControl.qml
//Created:Guang Yang 2087167099@qq.com        2026-07-13
//Version: 1.0      License: AGPLv3
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgSecondary
    radius: Style.radiusNormal

    Layout.preferredWidth: 150
    Layout.preferredHeight: 30

    RowLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingSmall
        spacing: 6

        Text {
            text: "🔊"
            font.pixelSize: 14
            color: Style.textSecondary
        }

        Slider {
            id: volumeSlider
            Layout.fillWidth: true
            from: 0
            to: 100

            Component.onCompleted: {
            volumeSlider.value = musicManager.volume * 100
            }

            onValueChanged: {
            musicManager.volume = volumeSlider.value / 100
            }

            background: Rectangle {
                color: Style.bgTertiary
                radius: 3
                height: 4
            }
        }
    }
}