// Module
// File:Main.qml  Version: 0.1.0   License: AGPLv3
// Created: Luojianqiu  2455043129@qq.com，TuJunfeng 2150319601@qq.com
// Description:develop a graphical user interface

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

        SongInfoPanel {}

        ProgressBar {}

        PlaybackControls {}

        PlaylistView {}
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