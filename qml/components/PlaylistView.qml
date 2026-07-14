// File:PlaylistView.qml   Version: 0.1.0   License: AGPLv3
// Created:Junfeng Tu  2150319601@qq.com
// Description: Playlist view component with song list, tap-to-play and delete

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import Music

GroupBox {
    id: root
    title: "播放列表 (" + musicManager.playlistModel.count + " 首)"

    Layout.fillWidth: true
    Layout.fillHeight: true

    property int deleteIndex: -1

    background: Rectangle {
        color: Style.bgSecondary
        radius: Style.radiusNormal
    }

    MessageDialog {
        id: deleteDialog
        title: "确认删除"
        text: "确定要删除这首歌曲吗？"
        buttons: MessageDialog.Ok | MessageDialog.Cancel

        onAccepted: {
            if (root.deleteIndex < 0 || root.deleteIndex >= musicManager.playlistModel.count) {
                root.deleteIndex = -1
                return
            }

            var wasCurrent = (root.deleteIndex === musicManager.playlistModel.currentIndex)
            musicManager.playlistModel.removeSong(root.deleteIndex)

            if (wasCurrent && musicManager.playlistModel.count > 0) {
                musicManager.playIndex(0)
            }

            root.deleteIndex = -1
        }

        onRejected: {
            root.deleteIndex = -1
        }
    }

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

                Rectangle {
                    width: 24
                    height: 24
                    radius: 12
                    color: deleteHovered ? Style.bgHover : "transparent"

                    property bool deleteHovered: false

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: index === musicManager.playlistModel.currentIndex ? "white" : Style.textSecondary
                        font.pixelSize: Style.fontSizeNormal
                    }

                    HoverHandler {
                        id: deleteHoverHandler
                        onHoveredChanged: parent.deleteHovered = hovered
                    }

                    TapHandler {
                        id: deleteTapHandler
                        onTapped: {
                            root.deleteIndex = index
                            deleteDialog.open()
                        }
                    }
                }
            }
        }

        ScrollBar.vertical: ScrollBar {}
    }
}