//Module
//File: Main.qml
//Created:Guang Yang 2087167099@qq.com &&JunFeng Tu 2150319601@qq.com       2026-07-14
//Version: 2.0      License: AGPLv3
// Description: 主窗口 — 网易云风格布局，支持播放列表/歌词视图切换
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
    title: "周易云音乐播放器"
    color: Style.bgPrimary

    property bool darkTheme: true
    property int currentView: 0
    onCurrentViewChanged: {
        if (currentView === 0) {
            mainStack.replace(mainStack.initialItem)
        } else if (currentView === 1) {
            mainStack.replace(lyricsComponent)
        } else {
            mainStack.replace(likedComponent)
        }
    }

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
        spacing: 0

        // 中部：侧边栏+主内容
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Sidebar {
                id: sidebar
                onViewChanged: function(view) { window.currentView = view }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: Style.spacingLarge
                spacing: Style.spacingLarge


                // 主内容区
            StackView {
                id: mainStack
                Layout.fillWidth: true
                Layout.fillHeight: true

                initialItem: PlaylistView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                    }

                    Component {
                        id: lyricsComponent
                        LyricsDisplay {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }

                    Component {
                        id: likedComponent
                        LikedSongsView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
            }
        }

        // 底部控制栏
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            color: Style.bgSecondary
            radius: 0

            // 顶部分割线
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Style.borderLight
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.spacingLarge
                anchors.rightMargin: Style.spacingLarge
                anchors.topMargin: Style.spacingSmall
                anchors.bottomMargin: Style.spacingSmall
                spacing: 0

                // 进度条
                ProgressBar {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20
                }

                // 三栏布局：左侧歌曲信息,中间控制按钮,右侧音量
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.spacingNormal

                    // 左侧：歌曲信息
                    SongInfoPanel {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 200
                    }

                    // 中间：控制按钮（居中）
                    PlaybackControls {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    }

                    // 右侧：音量控制
                    VolumeControl {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 200
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
//}


// 启动画面
    Rectangle {
        id: splashScreen
        anchors.fill: parent
        color: Style.bgPrimary
        z: 999

        Behavior on opacity {
            NumberAnimation { duration: 600; easing.type: Easing.OutCubic }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.spacingLarge

            // Logo 图标
            Text {
                text: "\u{1F3B5}"
                font.pixelSize: 64
                color: Style.accentRed
                Layout.alignment: Qt.AlignHCenter
            }

            // 标题
            Text {
                text: "周易音乐播放器"
                font.pixelSize: 28
                font.bold: true
                color: Style.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }

            // 副标题
            Text {
                text: "享受音乐，享受生活"
                font.pixelSize: Style.fontSizeNormal
                color: Style.textTertiary
                Layout.alignment: Qt.AlignHCenter
            }
        }

        //淡出时间
        Timer {
            interval: 2000
            running: true
            onTriggered: splashScreen.opacity = 0
        }

        // 淡出完成后移除
        onOpacityChanged: {
            if (opacity === 0) {
                destroyTimer.start()
            }
        }

        Timer {
            id: destroyTimer
            interval: 700
            onTriggered: splashScreen.destroy()
        }
    }
}