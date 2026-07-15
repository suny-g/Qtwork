// Module
// File: VolumeControl.qml
// Created: Guang Yang 2087167099@qq.com        2026-07-13
// Version: 2.0      License: AGPLv3
// Description:音量控制
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: "transparent"

    Layout.fillHeight: true
    Layout.minimumWidth: 120

    RowLayout {
        anchors.fill: parent
        spacing: Style.spacingSmall

        //音量图标（根据音量大小自动切换）
        Text {
            text: {
                if (musicManager.volume <= 0) return "\u{1F507}"
                if (musicManager.volume < 0.5) return "\u{1F509}"
                return "\u{1F50A}"
            }
            font.pixelSize: 14
            color: Style.textSecondary
        }

        //音量滑块
        Slider {
            id: volumeSlider
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            from: 0
            to: 100

            //初始化滑块值（将0~1映射到0~100）
            Component.onCompleted: {
                volumeSlider.value = musicManager.volume * 100
            }

            //当滑块值改变时，同步到musicManager
            onValueChanged: {
                musicManager.volume = volumeSlider.value / 100
            }

            //自定义背景轨道
            background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 80
                implicitHeight: 3
                width: volumeSlider.availableWidth
                height: implicitHeight
                radius: 1.5
                color: Style.bgTertiary

                //已调节部分（显示当前音量百分比）
                Rectangle {
                    width: volumeSlider.visualPosition * parent.width
                    height: parent.height
                    radius: 1.5
                    color: Style.textSecondary
                }
            }

            //自定义滑块手柄（悬停或按压时显示）
            handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 8
                implicitHeight: 8
                radius: 4
                color: Style.textPrimary
                visible: volumeSlider.hovered || volumeSlider.pressed
            }
        }
    }
}