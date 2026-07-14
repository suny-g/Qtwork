//Module
//File: LikedSongsView.qml
//Created:Guang Yang 2087167099@qq.com        2026-07-14
//Version: 1.0      License: AGPLv3
//liked songs list
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

GroupBox {
    id: root
    title: "我喜欢 (" + likedCount + " 首)"

    Layout.fillWidth: true
    Layout.fillHeight: true

    property int likedCount: 0

    function refresh() {
        var list = musicManager.playlistModel.likedSongs()
        likedModel.clear()
        for (var i = 0; i < list.length; i++) {
            likedModel.append(list[i])
        }
        likedCount = list.length
    }

    Component.onCompleted: refresh()// 组件加载完成时初始化

    Connections {
        target: musicManager.playlistModel
        function onLikedChanged() { refresh() }// 收藏状态变化时刷新
    }

    background: Rectangle {
        color: Style.bgSecondary
        radius: Style.radiusNormal
    }

    ListModel { id: likedModel }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 5
        model: likedModel
        clip: true

        Text {
            anchors.centerIn: parent
            visible: listView.count === 0
            text: "暂无收藏歌曲\n点击底部红心收藏喜欢的音乐"
            color: Style.textTertiary
            font.pixelSize: Style.fontSizeNormal
            horizontalAlignment: Text.AlignHCenter
        }

        delegate: Rectangle {
            width: listView.width
            height: 50
            color: hovered ? Style.bgHover : "transparent"
            radius: 4

            property bool hovered: false

            TapHandler {
                onTapped: {
                    //在播放列表中查找并播放
                    var idx = musicManager.playlistModel.count
                    for (var i = 0; i < idx; i++) {
                        if (musicManager.playlistModel.getUrl(i).toString() === model.url.toString()) {
                            musicManager.playIndex(i)
                            break
                        }
                    }
                }
            }

            HoverHandler {
                onHoveredChanged: parent.hovered = hovered
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: "\u2665"
                    font.pixelSize: Style.fontSizeSmall
                    color: Style.accentRed
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: model.title || "未知歌曲"
                        font.pixelSize: Style.fontSizeNormal
                        color: Style.textPrimary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: model.artist || "未知艺术家"
                        font.pixelSize: Style.fontSizeSmall
                        color: Style.textSecondary
                        elide: Text.ElideRight
                    }
                }

                Text {
                    text: Style.formatDuration(model.duration)
                    color: Style.textSecondary
                    font.pixelSize: Style.fontSizeSmall
                }
            }
        }

        ScrollBar.vertical: ScrollBar {}
    }
}