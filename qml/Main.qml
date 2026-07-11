// Module
// File:Main.qml  Version: 0.1.0   License: AGPLv3
// Created: Luojianqiu  2455043129@qq.com
// Description:develop a graphical user interface

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow {
    id: window
    width: 500
    height: 400
    visible: true
    title: "音乐播放器"

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
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        // 当前播放信息
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "#f0f0f0"
            radius: 8

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
                    font.pixelSize: 18
                    font.bold: true
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
                    font.pixelSize: 14
                    color: "gray"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // 进度条
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: formatTime(musicManager.position)
                font.pixelSize: 12
                color: "gray"
            }

            Slider {
                id: progressSlider
                Layout.fillWidth: true
                from: 0
                to: Math.max(musicManager.duration, 1)
                value: musicManager.position
                onMoved: musicManager.seek(value)
            }

            Text {
                text: formatTime(musicManager.duration)
                font.pixelSize: 12
                color: "gray"
            }
        }

        // 控制按钮
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            Button {
                text: "⏮"
                font.pixelSize: 24
                enabled: musicManager.playlistModel.count > 0
                onClicked: musicManager.previous()
            }

            Button {
                text: musicManager.isPlaying ? "⏸" : "▶"
                font.pixelSize: 30
                enabled: musicManager.playlistModel.count > 0
                onClicked: {
                    if (musicManager.isPlaying) {
                        musicManager.pause()
                    } else {
                        musicManager.play()
                    }
                }
            }

            Button {
                text: "⏭"
                font.pixelSize: 24
                enabled: musicManager.playlistModel.count > 0
                onClicked: musicManager.next()
            }

            Button {
                text: "⏹"
                font.pixelSize: 24
                enabled: musicManager.isPlaying
                onClicked: musicManager.stop()
            }

            // 播放模式切换按钮
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
                ToolTip.delay: 500
            }
        }

        // 播放列表
        GroupBox {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "播放列表 (" + musicManager.playlistModel.count + " 首)"

            ListView {
                id: listView
                anchors.fill: parent
                model: musicManager.playlistModel
                clip: true

                delegate: Rectangle {
                    width: listView.width
                    height: 40
                    color: index === musicManager.playlistModel.currentIndex ? "#e0e0e0" : "white"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10

                        Text {
                            text: index + 1
                            color: "gray"
                            font.pixelSize: 12
                            Layout.minimumWidth: 25
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: model.title || "未知歌曲"
                                font.pixelSize: 13
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        Text {
                            text: formatTime(model.duration)
                            color: "gray"
                            font.pixelSize: 12
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: musicManager.playIndex(index)
                    }
                }

                ScrollBar.vertical: ScrollBar {}
            }
        }
    }

    // 文件选择对话框
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

    // 元数据读取信号连接
    Connections {
        target: metadataReader
        function onMetadataReady(url, title, artist, album, duration) {
            musicManager.playlistModel.addSong(url, title, artist, album, duration)
            // 如果是第一首，自动播放
            if (musicManager.playlistModel.count === 1) {
                musicManager.playIndex(0)
            }
        }
    }

    // 辅助函数
    function formatTime(ms) {
        if (!ms || ms <= 0) return "0:00"
        var totalSeconds = Math.floor(ms / 1000)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)
    }
}