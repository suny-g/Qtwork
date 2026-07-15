// Module
// File: LikedSongsView.qml
// Created: Guang Yang 2087167099@qq.com        2026-07-14
// Version: 1.0      License: AGPLv3
// Description: 显示用户“我喜欢”的歌曲列表

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

GroupBox {
    id: root
    //标题显示收藏歌曲总数
    title: "我喜欢 (" + likedCount + " 首)"

    Layout.fillWidth: true
    Layout.fillHeight: true

    //收藏歌曲数量（用于界面绑定）
    property int likedCount: 0

    //刷新列表：从 C++ 模型获取最新收藏列表并更新内部 ListModel
    function refresh() {
        var list = musicManager.playlistModel.likedSongs()
        likedModel.clear()
        for (var i = 0; i < list.length; i++) {
            likedModel.append(list[i])
        }
        likedCount = list.length
    }

    //组件加载完成后立即刷新，显示已有收藏
    Component.onCompleted: refresh()

    //监听收藏状态变化信号（当在别处切换“喜欢”时触发）
    Connections {
        target: musicManager.playlistModel
        function onLikedChanged() { refresh() }
    }

    //样式背景（与项目风格统一）
    background: Rectangle {
        color: Style.bgSecondary
        radius: Style.radiusNormal
    }

    //内部 ListModel，用于存储当前展示的收藏歌曲
    ListModel { id: likedModel }

    //列表视图，显示收藏歌曲
    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 5
        model: likedModel
        clip: true

        //当列表为空时显示提示文字
        Text {
            anchors.centerIn: parent
            visible: listView.count === 0
            text: "暂无收藏歌曲\n点击底部红心收藏喜欢的音乐"
            color: Style.textTertiary
            font.pixelSize: Style.fontSizeNormal
            horizontalAlignment: Text.AlignHCenter
        }

        //每个收藏歌曲的委托项
        delegate: Rectangle {
            width: listView.width
            height: 50
            color: hovered ? Style.bgHover : "transparent"
            radius: 4

            property bool hovered: false

            //点击处理：在全局播放列表中查找该歌曲并播放
            TapHandler {
                onTapped: {
                    var count = musicManager.playlistModel.count
                    for (var i = 0; i < count; i++) {
                        //通过 URL 匹配歌曲
                        if (musicManager.playlistModel.getUrl(i).toString() === model.url.toString()) {
                            musicManager.playIndex(i)
                            break
                        }
                    }
                }
            }

            //悬停状态管理（配合上面的 color 变化）
            HoverHandler {
                onHoveredChanged: parent.hovered = hovered
            }

            //行内布局：❤️ 图标 + 歌曲信息 + 时长
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                //❤️ 红色心形图标（表示已收藏）
                Text {
                    text: "\u2665"
                    font.pixelSize: Style.fontSizeSmall
                    color: Style.accentRed
                }

                //歌曲标题和艺术家（垂直排列）
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

                //歌曲时长
                Text {
                    text: Style.formatDuration(model.duration)
                    color: Style.textSecondary
                    font.pixelSize: Style.fontSizeSmall
                }
            }
        }

        //滚动条
        ScrollBar.vertical: ScrollBar {}
    }
}