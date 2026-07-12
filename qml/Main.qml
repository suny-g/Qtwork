// Module
// File:Main.qml  Version: 0.1.0   License: AGPLv3
// Created: Luojianqiu  2455043129@qq.com，TuJunfeng 2150319601@qq.com
// Description:develop a graphical user interface

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Music

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    title: "音乐播放器 v1.0"
    color: Style.bgPrimary

    property bool darkTheme: true

    menuBar: MenuBar {
        Menu {
            title: "文件"
            Action {
                text: "打开音乐文件"
                shortcut: StandardKey.Open
                onTriggered: fileDialog.open()
            }
            Action {
                text: "退出"
                shortcut: StandardKey.Quit
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: "视图"
            Action {
                text: darkTheme ? "切换浅色主题" : "切换深色主题"
                onTriggered: {
                    darkTheme = !darkTheme
                    window.color = darkTheme ? Style.bgPrimary : "#f5f5f5"
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingLarge
        spacing: Style.spacingLarge

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: Style.bgSecondary
            radius: Style.radiusNormal

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 5

                Text {
                    text: {
                        var idx = musicManager.playlistModel.currentIndex
                        if (idx >= 0 && idx < musicManager.playlistModel.count) {
                            var item = musicManager.playlistModel.get(idx)
                            return item.title || "未知歌曲"
                        }
                        return "未播放"
                    }
                    font.pixelSize: Style.fontSizeTitle
                    font.bold: true
                    color: Style.textPrimary
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    text: {
                        var idx = musicManager.playlistModel.currentIndex
                        if (idx >= 0 && idx < musicManager.playlistModel.count) {
                            var item = musicManager.playlistModel.get(idx)
                            return item.artist || "未知艺术家"
                        }
                        return "请选择音乐文件"
                    }
                    font.pixelSize: Style.fontSizeNormal
                    color: Style.textSecondary
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Style.bgSecondary
            radius: Style.radiusNormal

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

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Style.bgSecondary
            radius: Style.radiusNormal

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

        GroupBox {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "播放列表 (" + musicManager.playlistModel.count + " 首)"
            background: Rectangle { color: Style.bgSecondary; radius: Style.radiusNormal }

            ListView {
                id: listView
                anchors.fill: parent
                anchors.margins: 5
                model: musicManager.playlistModel
                clip: true

                delegate: Rectangle {
                    width: listView.width
                    height: 50
                    color: index === musicManager.playlistModel.currentIndex ? Style.accentRed : (hovered ? Style.bgHover : "transparent")
                    radius: 4

                    property bool hovered: false

                    TapHandler {
                        onTapped: musicManager.playIndex(index)
                    }

                    HoverHandler {
                        onHoveredChanged: parent.hovered = hovered
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Text {
                            text: index + 1
                            color: index === musicManager.playlistModel.currentIndex ? "white" : Style.textSecondary
                            font.pixelSize: Style.fontSizeSmall
                            Layout.minimumWidth: 25
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: model.title || "未知歌曲"
                                font.pixelSize: Style.fontSizeNormal
                                color: index === musicManager.playlistModel.currentIndex ? "white" : Style.textPrimary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: model.artist || "未知艺术家"
                                font.pixelSize: Style.fontSizeSmall
                                color: index === musicManager.playlistModel.currentIndex ? "#ffd6d6" : Style.textSecondary
                                elide: Text.ElideRight
                            }
                        }

                        Text {
                            text: Style.formatDuration(model.duration)
                            color: index === musicManager.playlistModel.currentIndex ? "#ffd6d6" : Style.textSecondary
                            font.pixelSize: Style.fontSizeSmall
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {}
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "选择音频文件"
        fileMode: FileDialog.OpenFiles
        nameFilters: ["音频文件 (*.mp3 *.wav *.ogg *.flac *.m4a)", "所有文件 (*)"]
        onAccepted: {
            var files = selectedFiles
            for (var i = 0; i < files.length; i++) {
                metadataReader.readMetadata(files[i], i)
            }
        }
    }

    Connections {
        target: metadataReader
        function onMetadataReady(url, title, artist, album, duration) {
            musicManager.playlistModel.addSong(url, title, artist, album, duration)
            if (musicManager.playlistModel.count === 1) {
                musicManager.playIndex(0)
            }
        }
    }
}
