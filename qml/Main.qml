//Module
//File: SongInfoPanel.qml
//Created:Guang Yang 2087167099@qq.com &&JunFeng Tu 2150319601@qq.com       2026-07-13
//Version: 1.0      License: AGPLv3
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Music
import "components"

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

        // 1. 播放列表：占据所有剩余空间
        PlaylistView {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // 2. 底部控制栏（固定高度）
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 160        // 根据内容调整
            color: Style.bgSecondary
            radius: Style.radiusNormal

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.spacingNormal
                spacing: Style.spacingSmall

                // 进度条
                ProgressBar {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                }

                // 控制区：左侧歌曲信息 + 中间控制按钮 + 右侧音量
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.spacingLarge

                    // 左侧：歌曲信息（固定宽度）
                    SongInfoPanel {
                        Layout.preferredWidth: 250
                        Layout.fillHeight: true
                    }

                    // 中间：控制按钮（居中）
                    PlaybackControls {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    }

                    // 右侧：音量控制（固定宽度）
                    VolumeControl {
                        Layout.preferredWidth: 150
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    }
                }
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